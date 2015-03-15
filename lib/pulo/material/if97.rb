class IF97
  class << self
    def critical_temperature
      Temperature.kelvin(647.096)
    end
    def critical_pressure
      Pressure.megapascals(22.064)
    end
    def specific_gas_constant
      SpecificHeat.kilojoules_per_kilogram_kelvin(0.461526)
    end
    def critical_temperature
      Temperature.kelvin(647.096)
    end
    def critical_pressure
      Pressure.megapascals(22.064)
    end
    def critical_density
      Density.kilograms_per_cubic_meter(322)
    end

    def pressure_from_b23 temperature
      cf=[0.34805185628969*10**3,-0.11671859879975*10**1,0.10192970039326*10**-2,0.57254459862746*10**3,0.13918839778870*10**2]
      theta=temperature.value
      pi=cf[0]+cf[1]*theta+cf[2]*theta**2
      Pressure.new(pi,:megapascal)
    end
    def temperature_from_b23 pressure
      cf=[0.34805185628969*10**3,-0.11671859879975*10**1,0.10192970039326*10**-2,0.57254459862746*10**3,0.13918839778870*10**2]
      pi=pressure.value
      theta=cf[3]+((pi-cf[4])/cf[2])**0.5
      Temperature.new(theta,:kelvin)
    end

    def pressure_from_temperature_r4 temperature
      n1= 0.11670521452767*10**4;n6= 0.14915108613530*10**2;n2=-0.72421316703206*10**6;n7=-0.48232657361591*10**4;n3=-0.17073846940092*10**2
      n8= 0.40511340542057*10**6;n4= 0.12020824702470*10**5;n9=-0.23855557567849;n5=-0.32325550322333*10**7;n10=0.65017534844798*10**3
      t=temperature.value
      l=t+n9/(t-n10)
      a=l**2+n1*l+n2
      b=n3*l**2+n4*l+n5
      c=n6*l**2+n7*l+n8
      p=(2*c/(-b+(b**2-4*a*c)**0.5))**4
      Pressure.megapascals(p)
    end
    def temperature_from_pressure_r4 pressure
      n1= 0.11670521452767*10**4;n6= 0.14915108613530*10**2;n2=-0.72421316703206*10**6;n7=-0.48232657361591*10**4;n3=-0.17073846940092*10**2
      n8= 0.40511340542057*10**6;n4= 0.12020824702470*10**5;n9=-0.23855557567849;n5=-0.32325550322333*10**7;n10=0.65017534844798*10**3
      b=pressure.value**0.25
      e=b**2+n3*b+n6
      f=n1*b**2+n4*b+n7
      g=n2*b**2+n5*b+n8
      d=2*g/(-f-(f**2-4*e*g)**0.5)
      t=(n10+d-((n10+d)**2-4*(n9+n10*d))**0.5)/2
      Temperature.kelvin(t)
    end
    def other_props_r4 temperature,water
      cb=[1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,-6.74694450*10**5]
      theta=(temperature/critical_temperature).value
      tau=1-theta
      rho=(1+cb[0]*tau**(1/3)+cb[1]*tau**(2/3)+cb[2]*tau**(5/3)+cb[3]*tau**(16/3)+cb[4]*tau**(43/3)+cb[5]*tau**(110/3))
      water.specific_volume_liquid=1/(rho*critical_density)
      cc=[-2.03150240,-2.68302940,-5.38626492,-17.2991605,-44.7586581,-63.9201063]
      rho2=(cc[0]*tau**(2/6)+cc[1]*tau**(4/6)+cc[2]*tau**(8/6)+cc[3]*tau**(18/6)+cc[4]*tau**(37/6)+cc[5]*tau**(71/6))
      water.specific_volume=1/(Math.exp(rho2)*critical_density)
    end

    def other_props_r1 temperature,pressure,water

      cf=[
          [0 ,-2 , 0.14632971213167],[0 ,-1 ,-0.84548187169114],[0 , 0 ,-0.37563603672040*10**1],[0 , 1 , 0.33855169168385*10**1],[0 , 2 ,-0.95791963387872],[0 , 3 , 0.15772038513228],[0 , 4 ,-0.16616417199501*10**-1 ],[0 , 5 , 0.81214629983568*10**-3 ],[1 ,-9 , 0.28319080123804*10**-3 ],[1 ,-7 ,-0.60706301565874*10**-3 ],[1 ,-1 ,-0.18990068218419*10**-1 ],[1 , 0 ,-0.32529748770505*10**-1 ],[1 , 1 ,-0.21841717175414*10**-1 ],[1 , 3 ,-0.52838357969930*10**-4 ],[2 ,-3 ,-0.47184321073267*10**-3 ],[2 , 0 ,-0.30001780793026*10**-3 ],
          [2 , 1 , 0.47661393906987*10**-4 ],[2 , 3 ,-0.44141845330846*10**-5 ],[2 , 17,-0.72694996297594*10**-15],[3 ,-4 ,-0.31679644845054*10**-4 ],[3 , 0 ,-0.28270797985312*10**-5 ],[3 , 6 ,-0.85205128120103*10**-9 ],[4 ,-5 ,-0.22425281908000*10**-5 ],[4 ,-2 ,-0.65171222895601*10**-6 ],[4 , 10,-0.14341729937924*10**-12],[5 ,-8 ,-0.40516996860117*10**-6 ],
          [8 ,-11,-0.12734301741641*10**-8 ],[8 , -6,-0.17424871230634*10**-9 ],[21,-29,-0.68762131295531*10**-18],[23,-31, 0.14478307828521*10**-19],[29,-38, 0.26335781662795*10**-22],[30,-39,-0.11947622640071*10**-22],[31,-40, 0.18228094581404*10**-23],[32,-41,-0.93537087292458*10**-25]]
      p_star=16.53
      t_star=1386.0
      tau=t_star/temperature.kelvin.value
      pi=pressure.megapascals.value/p_star
      dpi=cf.inject(0) do |sum,cfi|
        sum+(-cfi[2]*cfi[0]*(7.1-pi)**(cfi[0]-1)*(tau-1.222)**cfi[1])
      end
      dtau=cf.inject(0) do |sum,cfi|
        sum+(cfi[2]*(7.1-pi)**cfi[0]*cfi[1]*(tau-1.222)**(cfi[1]-1))
      end
      gam=cf.inject(0) do |sum,cfi|
        sum+(cfi[2]*(7.1-pi)**cfi[0]*(tau-1.222)**cfi[1])
      end

      water.temperature||=temperature
      water.pressure||=pressure
      water.specific_volume=pi*dpi*specific_gas_constant*temperature/pressure

      water.specific_internal_energy=(tau*dtau-pi*dpi)*specific_gas_constant*temperature
      water.specific_entropy=(tau*dtau-gam)*specific_gas_constant
      water.specific_enthalpy=(tau*dtau)*specific_gas_constant*temperature
    end
    def temperature_from_pressure_enthalpy_r1 pressure, specific_enthalpy,water
      cf=[
        [0,0,-0.23872489924521*10**3],[0,1,0.40421188637945*10**3],[0,2,0.11349746881718*10**3],[0,6,-0.58457616048039*10**1],[0,22,-0.15285482413140*10**-3],[0,32,-0.10866707695377*10**-5],[1,0,-0.13391744872602*10**2],[1,1,0.43211039183559*10**2],[1,2,-0.54010067170506*10**2],[1,3,0.30535892203916*10**2],
        [1,4,-0.65964749423638*10**1],[1,10,0.93965400878363*10**-2],[1,32,0.11573647505340*10**-6],[2,10,-0.25858641282073*10**-4],[2,32,-0.40644363084799*10**-8],[3,10,0.66456186191635*10**-7],[3,32,0.80670734103027*10**-10],[4,32,-0.93477771213947*10**-12],[5,32,0.58265442020601*10**-14],[6,32,-0.15020185953503*10**-16]]
      pi=pressure.value
      eta=(specific_enthalpy.kilojoules_per_kilogram.value/SpecificEnthalpy.kilojoules_per_kilogram(2500.0).value)
      water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
        sum+(cfi[2]*pi**cfi[0]*(eta+1.0)**cfi[1])
      end)
      water.specific_enthalpy||=specific_enthalpy
      water.pressure||=pressure
    end
    def temperature_from_pressure_entropy_r1 pressure,specific_entropy,water
      cf=[
          [0,0,0.17478268058307*10**3],[0,1,0.34806930892873*10**2],[0,2,0.65292584978455*10**1],[0,3,0.33039981775489],[0,11,-0.19281382923196*10**-6],[0,31,-0.24909197244573*10**-22],[1,0,-0.26107636489332],
          [1,1,0.22592965981586],[1,2,-0.64256463395226*10**-1],[1,3,0.78876289270526*10**-2],[1,12,0.35672110607366*10**-9],[1,31,0.17332496994895*10**-23],[2,0,0.56608900654837*10**-3],[2,1,-0.32635483139717*10**-3],[2,2,0.44778286690632*10**-4],
          [2,9,-0.51322156908507*10**-9],[2,31,-0.42522657042207*10**-25],[3,10,0.26400441360689*10**-12],[3,32,0.78124600459723*10**-28],[4,32,-0.30732199903668*10**-30]]
      pi=pressure.value
      delta=specific_entropy.kilojoules_per_kilogram_kelvin.value

      water.pressure||=pressure
      water.specific_entropy||=specific_entropy
      water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
        sum+(cfi[2]*pi**cfi[0]*(delta+2)**cfi[1])
      end)

    end

    def other_props_r2 temperature,pressure,water
      cfo=[
          [0,-0.96927686500217*10**1],[1,0.10086655968018*10**2],[-5,-0.56087911283020*10**-2],
          [-4,0.71452738081455*10**-1],[-3,-0.40710498223928],[-2,0.14240819171444*10**1],[-1,-0.43839511319450*10**1],[2,-0.28408632460772],[3,0.21268463753307*10**-1]]
      cfr=[
          [1,0,-0.17731742473213*10**-2],[1,1,-0.17834862292358*10**-1],[1,2,-0.45996013696365*10**-1],[1,3,-0.57581259083432*10**-1],[1,6,-0.50325278727930*10**-1],[2,1,-0.33032641670203*10**-4],[2,2,-0.18948987516315*10**-3],[2,4,-0.39392777243355*10**-2],[2,7,-0.43797295650573*10**-1],[2,36,-0.26674547914087*10**-4],
          [3,0,0.20481737692309*10**-7],[3,1,0.43870667284435*10**-6],[3,3,-0.32277677238570*10**-4],[3,6,-0.15033924542148*10**-2],[3,35,-0.40668253562649*10**-1],[4,1,-0.78847309559367*10**-9],[4,2,0.12790717852285*10**-7],[4,3,0.48225372718507*10**-6],[5,7,0.22922076337661*10**-5],
          [6,3,-0.16714766451061*10**-10],[6,16,-0.21171472321355*10**-2],[6,35,-0.23895741934104*10**2],[7,0,-0.59059564324270*10**-17],[7,11,-0.12621808899101*10**-5],[7,25,-0.38946842435739*10**-1],[8,8,0.11256211360459*10**-10],[8,36,-0.82311340897998*10**1],
          [9,13,0.19809712802088*10**-7],[10,4,0.10406965210174*10**-18],[10,10,-0.10234747095929*10**-12],[10,14,-0.10018179379511*10**-8],[16,29,-0.80882908646985*10**-10],[16,50,0.10693031879409],[18,57,-0.33662250574171],[20,20,0.89185845355421*10**-24],
          [20,35,0.30629316876232*10**-12],[20,48,-0.42002467698208*10**-5],[21,21,-0.59056029685639*10**-25],[22,53,0.37826947613457*10**-5],[23,39,-0.12768608934681*10**-14],[24,26,0.73087610595061*10**-28],[24,40,0.55414715350778*10**-16],[24,58,-0.94369707241210*10**-6]]
      pi=pressure.value
      tau=(Temperature.kelvin(540)/temperature.kelvin).value
      gamma_r_pi=cfr.inject(0) do |sum,cfr|
        sum+(cfr[2]*cfr[0]*pi**(cfr[0]-1)*(tau-0.5)**cfr[1])
      end
      gamma_o_pi=1.0/pi
      gamma_r_tau=cfr.inject(0) do |sum,cfr|
        sum+(cfr[2]*pi**cfr[0]*cfr[1]*(tau-0.5)**(cfr[1]-1))
      end
      gamma_o_tau=cfo.inject(0) do |sum,cfo|
        sum+(cfo[1]*cfo[0]*tau**(cfo[0]-1))
      end
      gamma_r=cfr.inject(0) do |sum,cfr|
        sum+(cfr[2]*pi**cfr[0]*(tau-0.5)**cfr[1])
      end
      gamma_o=Math.log(pi) + cfo.inject(0) do |sum,cfo|
        sum+(cfo[1]*tau**cfo[0])
      end

      water.temperature||=temperature
      water.pressure||=pressure
      water.specific_volume=(pi*(gamma_o_pi+gamma_r_pi))*specific_gas_constant*temperature/pressure

      water.specific_internal_energy=(tau*(gamma_o_tau+gamma_r_tau)-pi*(gamma_o_pi+gamma_r_pi))*specific_gas_constant*temperature
      water.specific_entropy=(tau*(gamma_o_tau+gamma_r_tau)-(gamma_o+gamma_r))*specific_gas_constant
      water.specific_enthalpy=(tau*(gamma_o_tau+gamma_r_tau))*specific_gas_constant*temperature
    end
    def b2bc pressure
      cf=[0.90584278514723*10**3,
          -0.67955786399241,
          0.12809002730136*10**-3,
          0.26526571908428*10**4,
          0.45257578905948*10**1]
      pi=pressure.megapascals.value
      n=cf[3]+((pi-cf[4])/cf[2])**0.5
      SpecificEnthalpy.new(n,:kilojoule_per_kilogram)
    end
    def temperature_from_pressure_enthalpy_r2 pressure,specific_enthalpy,water
      raise "Specific enthalpy too high for region 2" if specific_enthalpy>SpecificEnergy.kilojoules_per_kilogram(4142.5)
      if pressure>=Pressure.megapascals(4)
        if pressure<Pressure.megapascals(6.54670) || specific_enthalpy>=b2bc(pressure)
          #2b
          cf=[[0,0,0.14895041079516*10**4],[0,1,0.74307798314034*10**3],[0,2,-0.97708318797837*10**2],[0,12,0.24742464705674*10**1],[0,18,-0.63281320016026],[0,24,0.11385952129658*10**1],[0,28,-0.47811863648625],[0,40,0.85208123431544*10**-2],[1,0,0.93747147377932],[1,2,0.33593118604916*10**1],[1,6,0.33809355601454*10**1],[1,12,0.16844539671904],[1,18,0.73875745236695],[1,24,-0.47128737436186],[1,28,0.15020273139707],[1,40,-0.21764114219750*10**-2],
          [2,2,-0.21810755324761*10**-1],[2,8,-0.10829784403677],[2,18,-0.46333324635812*10**-1],[2,40,0.71280351959551*10**-4],[3,1,0.11032831789999*10**-3],[3,2,0.18955248387902*10**-3],[3,12,0.30891541160537*10**-2],[3,24,0.13555504554949*10**-2],[4,2,0.28640237477456*10**-6],[4,12,0.10779857357512*10**-4],[4,18,0.76462712454814*10**-4],
          [4,24,0.14052392818316*10**-4],[4,28,0.31083814331434*10**-4],[4,40,0.10302738212103*10**-5],[5,18,0.28217281635040*10**-6],[5,24,0.12704902271945*10**-5],[5,40,0.73803353468292*10**-7],[6,28,0.11030139238909*10**-7],[7,2,0.81456365207833*10**-13],[7,28,0.25180545682962*10**-10],[9,1,0.17565233969407*10**-17],[9,40,0.86934156344163*10**-14]]
          pi=pressure.value
          n=(specific_enthalpy/SpecificEnthalpy.kilojoules_per_kilogram(2000)).value
          water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
            sum+(cfi[2]*(pi-2)**cfi[0]*(n-2.6)**cfi[1])
          end)
        else
          #2c
          cf=[
          [-7,0,-0.32368398555242*10**13],[-7,4,0.73263350902181*10**13],[-6,0,0.35825089945447*10**12],[-7,2,-0.58340131851590*10**12],[-5,0,-0.10783068217470*10**11],[-5,2,0.20825544563171*10**11],[-2,0,0.61074783564516*10**6],[-2,1,0.85977722535580*10**6],[-1,0,-0.25745723604170*10**5],[-1,2,0.31081088422714*10**5],[0,0,0.12082315865936*10**4],[0,1,0.48219755109255*10**3],
          [1,4,0.37966001272486*10**1],[1,8,-0.10842984880077*10**2],[2,4,-0.45364172676660*10**-1],[6,0,0.14559115658698*10**-12],[6,1,0.11261597407230*10**-11],[6,4,-0.17804982240686*10**-10],[6,10,0.12324579690832*10**-6],[6,12,-0.11606921130984*10**-5],[6,16,0.27846367088554*10**-4],[6,20,-0.59270038474176*10**-3],[6,22,0.12918582991878*10**-2]]
          pi=pressure.value
          n=(specific_enthalpy/SpecificEnthalpy.kilojoules_per_kilogram(2000)).value
          water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
            sum+(cfi[2]*(pi+25)**cfi[0]*(n-1.8)**cfi[1])
          end)
        end
      else
        #2a
        cf=[
        [0,0,0.10898952318288*10**4],[0,1,0.84951654495535*10**3],[0,2,-0.10781748091826*10**3],[0,3,0.33153654801263*10**2],[0,7,-0.74232016790248*10**1],[0,20,0.11765048724356*10**2],[1,0,0.18445749355790*10**1],[1,1,-0.41792700549624*10**1],[1,2,0.62478196935812*10**1],[1,3,-0.17344563108114*10**2],[1,7,-0.20058176862096*10**3],[1,9,0.27196065473796*10**3],[1,11,-0.45511318285818*10**3],
        [1,18,0.30919688604755*10**4],[1,44,0.25226640357872*10**6],[2,0,-0.61707422868339*10**-2],[2,2,-0.31078046629583],[2,7,0.11670873077107*10**2],[2,36,0.12812798404046*10**9],[2,38,-0.98554909623276*10**9],[2,40,0.28224546973002*10**10],[2,42,-0.35948971410703*10**10],[2,44,0.17227349913197*10**10],[3,24,-0.13551334240775*10**5],
        [3,44,0.12848734664650*10**8],[4,12,0.13865724283226*10**1],[4,32,0.23598832556514*10**6],[4,44,-0.13105236545054*10**8],[5,32,0.73999835474766*10**4],[5,36,-0.55196697030060*10**6],[5,42,0.37154085996233*10**7],[6,34,0.19127729239660*10**5],[6,44,-0.41535164835634*10**6],[7,28,-0.62459855192507*10**2]]

        pi=pressure.value
        n=(specific_enthalpy.kilojoules_per_kilogram.value/2000.0)
        water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
          sum+(cfi[2]*pi**cfi[0]*(n-2.1)**cfi[1])
        end)
      end
      water.pressure||=pressure
      water.specific_enthalpy||=specific_enthalpy
    end
    def temperature_from_pressure_entropy_r2 pressure,specific_entropy,water
      if pressure>=Pressure.megapascals(4)
        if specific_entropy>=SpecificEntropy.joules_per_kilogram_kelvin(5.85)
          #2b
          cf=[[-6,0,0.31687665083497*10**6],[-6,11,0.20864175881858*10**2],[-5,0,-0.39859399803599*10**6],[-5,11,-0.21816058518877*10**2],[-4,0,0.22369785194242*10**6],[-4,1,-0.27841703445817*10**4],[-4,11,0.99207436071480*10**1],[-3,0,-0.75197512299157*10**5],
              [-3,1,0.29708605951158*10**4],[-3,11,-0.34406878548526*10**1],[-3,12,0.38815564249115],[-2,0,0.17511295085750*10**5],[-2,1,-0.14237112854449*10**4],[-2,6,0.10943803364167*10**1],[-2,10,0.89971619308495],[-1,0,-0.33759740098958*10**4],[-1,1,0.47162885818355*10**3],
              [-1,5,-0.19188241993679*10**1],[-1,8,0.41078580492196],[-1,9,-0.33465378172097],[0,0,0.13870034777505*10**4],[0,1,-0.40663326195838*10**3],[0,2,0.41727347159610*10**2],[0,4,0.21932549434532*10**1],[0,5,-0.10320050009077*10**1],[0,6,0.35882943516703],
              [0,9,0.52511453726066*10**-2],[1,0,0.12838916450705*10**2],[1,1,-0.28642437219381*10**1],[1,2,0.56912683664855],[1,3,-0.99962954584931*10**-1],[1,7,-0.32632037778459*10**-2],[1,8,0.23320922576723*10**-3],[2,0,-0.15334809857450],[2,1,0.29072288239902*10**-1],
              [2,5,0.37534702741167*10**-3],[3,0,0.17296691702411*10**-2],[3,1,-0.38556050844504*10**-3],[3,3,-0.35017712292608*10**-4],[4,0,-0.14566393631492*10**-4],[4,1,0.56420857267269*10**-5],[5,0,0.41286150074605*10**-7],[5,1,-0.20684671118824*10**-7],[5,2,0.16409393674725*10**-8]]
          pi=pressure.megapascals.value
          delta=(specific_entropy/SpecificEntropy.kilojoules_per_kilogram_kelvin(0.7853)).value
          water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
            sum+(cfi[2]*pi**cfi[0]*(10-delta)**cfi[1])
          end)
        else
          #2c
          cf=[[-2,0,0.90968501005365*10**3],[-2,1,0.24045667088420*10**4],[-1,0,-0.59162326387130*10**3],[0,0,0.54145404128074*10**3],[0,1,-0.27098308411192*10**3],
              [0,2,0.97976525097926*10**3],[0,3,-0.46966772959435*10**3],[1,0,0.14399274604723*10**2],[1,1,-0.19104204230429*10**2],[1,3,0.53299167111971*10**1],[1,4,-0.21252975375934*10**2],[2,0,-0.31147334413760],[2,1,0.60334840894623],[2,2,-0.42764839702509*10**-1],
              [3,0,0.58185597255259*10**-2],[3,1,-0.14597008284753*10**-1],[3,5,0.56631175631027*10**-2],[4,0,-0.76155864584577*10**-4],[4,1,0.22440342919332*10**-3],[4,4,-0.12561095013413*10**-4],[5,0,0.63323132660934*10**-6],[5,1,-0.20541989675375*10**-5],[5,2,0.36405370390082*10**-7],
              [6,0,-0.29759897789215*10**-8],[6,1,0.10136618529763*10**-7],[7,0,0.59925719692351*10**-11],[7,1,-0.20677870105164*10**-10],[7,3,-0.20874278181886*10**-10],[7,4,0.10162166825089*10**-9],[7,5,-0.16429828281347*10**-9]]
          pi=pressure.value
          delta=(specific_entropy/SpecificEntropy.kilojoules_per_kilogram_kelvin(2.9251)).value
          water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
            sum+(cfi[2]*pi**cfi[0]*(2-delta)**cfi[1])
          end)
        end
      else
        #2a
        cf=[[-1.5,-24,-0.39235983861984*10**6],[-1.5,-23,0.51526573827270*10**6],[-1.5,-19,0.40482443161048*10**5],[-1.5,-13,-0.32193790923902*10**3],
            [-1.5,-11,0.96961424218694*10**2],[-1.5,-10,-0.22867846371773*10**2],[-1.25,-19,-0.44942914124357*10**6],[-1.25,-15,-0.50118336020166*10**4],[-1.25,-6,0.35684463560015],[-1.0,-26,0.44235335848190*10**5],[-1.0,-21,-0.13673388811708*10**5],[-1.0,-17,0.42163260207864*10**6],[-1.0,-16,0.22516925837475*10**5],[-1.0,-9,0.47442144865646*10**3],[-1.0,-8,-0.14931130797647*10**3],[-0.75,-15,-0.19781126320452*10**6],[-0.75,-14,-0.23554399470760*10**5],[-0.5,-26,-0.19070616302076*10**5],
            [-0.5,-13,0.55375669883164*10**5],[-0.5,-9,0.38293691437363*10**4],[-0.5,-7,-0.60391860580567*10**3],[-0.25,-27,0.19363102620331*10**4],[-0.25,-25,0.42660643698610*10**4],[-0.25,-11,-0.59780638872718*10**4],[-0.25,-6,-0.70401463926862*10**3],[0.25,1,0.33836784107553*10**3],[0.25,4,0.20862786635187*10**2],[0.25,8,0.33834172656196*10**-1],[0.25,11,-0.43124428414893*10**-4],[0.5,0,0.16653791356412*10**3],[0.5,1,-0.13986292055898*10**3],[0.5,5,-0.78849547999872],
            [0.5,6,0.72132411753872*10**-1],[0.5,10,-0.59754839398283*10**-2],[0.5,14,-0.12141358953904*10**-4],[0.5,16,0.23227096733871*10**-6],[0.75,0,-0.10538463566194*10**2],[0.75,4,0.20718925496502*10**1],[0.75,9,-0.72193155260427*10**-1],[0.75,17,0.20749887081120*10**-6],[1.0,7,-0.18340657911379*10**-1],[1.0,18,0.29036272348696*10**-6],[1.25,3,0.21037527893619],[1.25,15,0.25681239729999*10**-3],[1.5,5,-0.12799002933781*10**-1],[1.5,18,-0.82198102652018*10**-5]]
        pi=pressure.value
        delta=(specific_entropy/SpecificEntropy.kilojoules_per_kilogram_kelvin(2)).value
        water.temperature=Temperature.kelvin(cf.inject(0) do |sum,cfi|
          sum+(cfi[2]*pi**cfi[0]*(delta-2)**cfi[1])
        end)
      end
      water.pressure||=pressure
      water.specific_entropy||=specific_entropy
    end

    def other_props_r3
  #  cf=[['_','_',-0.10658070028513*10**1],[0,0,-0.15732845290239*10**2],[0,1,0.20944396974307*10**2],[0,2,-0.76867707878716*10**1],[0,7,0.26185947787954*10**1],[0,10,-0.28080781148620*10**1],[0,12,0.12053369696517*10**1],[0,23,-0.84566812812502*10**-2],[1,2,-0.12654315477714*10**1],[1,6,-0.11524407806681*10**1],[1,15,0.88521043984318],[1,17,-0.64207765181607],
  #      [2,0,0.38493460186671],[2,2,-0.85214708824206],[2,6,0.48972281541877*10**1],[2,7,-0.30502617256965*10**1],[2,22,0.39420536879154*10**-1],[2,26,0.12558408424308],[3,0,-0.27999329698710],[3,2,0.13899799569460*10**1],[3,4,-0.20189915023570*10**1],[3,16,-0.82147637173963*10**-2],
  #      [3,26,-0.47596035734923],[4,0,0.43984074473500*10**-1],[4,2,-0.44476435428739],[4,4,0.90572070719733],[4,26,0.70522450087967],[5,1,0.10770512626332],[5,3,-0.32913623258954],[5,26,-0.50871062041158],[6,0,-0.22175400873096*10**-1],
  #      [6,2,0.94260751665092*10**-1],[6,26,0.16436278447961],[7,2,-0.13503372241348*10**-1],[8,26,-0.14834345352472*10**-1],[9,2,0.57922953628084*10**-3],[9,26,0.32308904703711*10**-2],[10,0,0.80964802996215*10**-4],[10,1,-0.16557679795037*10**-3],[11,26,-0.44923899061815*10**-4]]
  end

    def get_region_ph pressure,specific_enthalpy
      p132=Pressure.megapascals(16.529164252604478)
      h13=SpecificEnthalpy.kilojoules_per_kilogram(1670.8582182745835)
      h32=SpecificEnthalpy.kilojoules_per_kilogram(2563.592004)

      if specific_enthalpy<h13 && pressure<p132
        return chkh_r1_r4 pressure,specific_enthalpy
      end
      if specific_enthalpy<h13 && pressure>p132
        return chkh_r1_r3  pressure,specific_enthalpy
      end
      if pressure<p132 && specific_enthalpy>h13 && specific_enthalpy<h32
        return 4
      end
      if specific_enthalpy>h32 and pressure<p132
        return chkh_r2_r4 pressure,specific_enthalpy
      end
      if specific_enthalpy>h13 && specific_enthalpy<h32 && pressure<critical_pressure
        return chkh_r3_r4 pressure,specific_enthalpy
      end
      if pressure>p132 && specific_enthalpy>h13
        return chkh_r2_r3 pressure,specific_enthalpy
      end
      raise "Region not identified for h: #{specific_enthalpy.to_s} and p: #{pressure.to_s}"
    end
    def chkh_r1_r4 pressure,specific_enthalpy
      ts=temperature_from_pressure_r4 pressure
      w=WaterSteam.new
      other_props_r1(ts,pressure,w)
      if w.specific_enthalpy>specific_enthalpy then 1 else 4 end
    end
    def chkh_r3_r4 pressure,specific_enthalpy
      #cf=[[0,0,0.639767553612785],[1,1,-0.129727445393014*10**2],[1,32,-0.224595125848403*10**16],[4,7,0.177466741801846*10**7],[12,4,0.717079349571538*10**10],[12,14,-0.378829107169011*10**18],[16,36,-0.955586736431328*10**35],[24,10,0.187269814676188*10**24],[28,0,0.119254746466473*10**12],[32,18,0.110649277244882*10**37]]
      #delta=(specific_entropy/SpecificEntropy.kilojoules_per_kilogram_kelvin(5.2)).value
      #p3s=Pressure.megapascals(cf.inject(0) do |sum,cfi|
      #  sum+(cfi[2]*(delta-1.03)**cfi[0]*(delta-0.699)**cfi[1])
      #end*22)
      #p p3s.to_s
      #if p3s>pressure then 4 else 3 end
      raise "not implemented 4 3"
    end
    def chkh_r2_r4 pressure,specific_enthalpy
      ts=temperature_from_pressure_r4 pressure
      w=WaterSteam.new
      other_props_r2(ts,pressure,w)
      if w.specific_enthalpy>specific_enthalpy then 4 else 2 end
    end
    def chkh_r1_r3 pressure,specific_enthalpy
      w=WaterSteam.new
      other_props_r1(Temperature.kelvin(623.15),pressure,w)
      if specific_enthalpy>w.specific_enthalpy then 3 else 1 end
    end
    def chkh_r2_r3 pressure,specific_enthalpy
      raise "not implemented 2 3"
      t=temperature_from_b23 pressure
      w=WaterSteam.new
      other_props_r2(t,pressure,w)
      if w.specific_enthalpy>specific_enthalpy then 3 else 2 end
    end

    def get_region_ps pressure,specific_entropy
      p132=Pressure.megapascals(16.529164252604478)
      s13=SpecificEntropy.kilojoules_per_kilogram_kelvin(3.77828133954424)
      s32=SpecificEntropy.kilojoules_per_kilogram_kelvin(5.210887824930662)
      if specific_entropy<s13 && pressure<p132
        return chk_r1_r4 pressure,specific_entropy
      end
      if specific_entropy<s13 && pressure>p132
        return chk_r1_r3  pressure,specific_entropy
      end
      if pressure<p132 && specific_entropy>s13 && specific_entropy<s32
        return 4
      end
      if specific_entropy>s32 and pressure<p132
        return chk_r2_r4 pressure,specific_entropy
      end
      if specific_entropy>s13 && specific_entropy<s32 && pressure<critical_pressure
        return chk_r3_r4 pressure,specific_entropy
      end
      if pressure>p132 && specific_entropy>s13
        return chk_r2_r3 pressure,specific_entropy
      end

      raise "Region not identified for s: #{specific_entropy.to_s} and p: #{pressure.to_s}"
    end
    def chk_r1_r4 pressure,specific_entropy
      ts=temperature_from_pressure_r4 pressure
      w=WaterSteam.new
      other_props_r1(ts,pressure,w)
      if w.specific_entropy>specific_entropy then 1 else 4 end
    end
    def chk_r3_r4 pressure,specific_entropy
      cf=[[0,0,0.639767553612785],[1,1,-0.129727445393014*10**2],[1,32,-0.224595125848403*10**16],[4,7,0.177466741801846*10**7],[12,4,0.717079349571538*10**10],[12,14,-0.378829107169011*10**18],[16,36,-0.955586736431328*10**35],[24,10,0.187269814676188*10**24],[28,0,0.119254746466473*10**12],[32,18,0.110649277244882*10**37]]
      delta=(specific_entropy/SpecificEntropy.kilojoules_per_kilogram_kelvin(5.2)).value
      p3s=Pressure.megapascals(cf.inject(0) do |sum,cfi|
        sum+(cfi[2]*(delta-1.03)**cfi[0]*(delta-0.699)**cfi[1])
      end*22)
      p p3s.to_s
      if p3s>pressure then 4 else 3 end
    end
    def chk_r2_r4 pressure,specific_entropy
      ts=temperature_from_pressure_r4 pressure
      w=WaterSteam.new
      other_props_r2(ts,pressure,w)
      if w.specific_entropy>specific_entropy then 4 else 2 end
    end
    def chk_r1_r3 pressure,specific_entropy
      w=WaterSteam.new
      other_props_r1(Temperature.kelvin(623.15),pressure,w)
      if specific_entropy>w.specific_entropy then 3 else 1 end
    end
    def chk_r2_r3 pressure,specific_entropy
      t=temperature_from_b23 pressure
      w=WaterSteam.new
      other_props_r2(t,pressure,w)
      if w.specific_entropy>specific_entropy then 3 else 2 end
    end
  end
end