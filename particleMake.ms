  


fn linker childName: parentName: =
(
   local childrens = #(), parents = #()
   for o in objects do 
   (
      if matchpattern o.name pattern:(childName+"*") ignoreCase:on do append childrens o.name
      if matchpattern o.name pattern:(parentName+"*") ignoreCase:on do append parents o.name
   )
 
   sort childrens ; sort parents
   --format "parents = % \nchildrens = %\n" parents childrens
   for c in childrens where (i = findItem parents (parentName+(trimleft c childName))) != 0 do
   (
      (getnodebyname c).parent = (getnodebyname parents[i])
   )
)

fn add_smoke =(
   
     wind2 = wind()
     wind2.strength = 0
     wind2.Turbulence = 0.2
     wind2.Frequency = 10
     wind2.baseobject.Scale = 0.04
     wind2.rotation.x_rotation = -90
     pf2 = PF_source()
     pf2.rotation.x_rotation= 76.241
     pf2.rotation.y_rotation=15.542
     pf2.rotation.z_rotation=-22.422
      pf2.particle_AMount_Limit = 50000000
      pf2.Quantity_Viewport = 100
      particleFlow.beginEdit()
      rend = RenderParticles()
      pf2.insertAction rend 1
      
      ev2 = Event()
      ev2.setPViewLocation 534 270
      bir = Birth()
      ev2.insertAction bir 1
      
      posObj = Position_Object()
      ev2.insertAction posObj 2
      posObj.Emitter_Objects = #($'Sphere001')
      posObj.Density_By_Emitter_Material = on
      bir.Emit_Start = -4000 -- -25
      bir.Emit_Stop = 48000 -- 300
      bir.amount = 100000 --파티클 개수
      
      forc = Force()
      ev2.insertAction forc 3
      forc.Force_Space_Warps = #($'Wind001')
      
     ageTest = Age_Test()
      ev2.insertAction ageTest 4
     ageTest.Test_Value = 960 --val = 6
     ageTest.variation = 320 --val = 2
     --------------ev3--------------------------
     ev3 = Event()
     ev3.setPViewLocation 640 434
     
     ev3spd = Speed()
     ev3spd.speed = 75
     ev3.insertAction ev3spd 1
     
     ev3Forc = Force()
     ev3.insertAction ev3Forc 2
     ev3Forc.Force_Space_Warps = #($'Wind002')
     
     ev3SapFac = Shape_Facing()
     ev3.insertAction ev3SapFac 3
     ev3SapFac.Look_At_Object= $'Camera001'
     
     ev3Mat= Material_Static()
     ev3.insertAction ev3Mat 4
     --Smoke Material 생성
     matSmoke = standardMaterial()
     matSmoke.opacity = 5
     col = Color 104 104 104
     matSmoke.diffuse = col
     ev3Mat.Assigned_Material = matSmoke
     
     ev3dp = DeleteParticles()
     ev3.insertAction ev3dp 5
     
     ev3dp.type = 2
     ev3dp.Life_Span = 10400 --65
     ev3dp.variation = 0 --0
     
     ev3dis = DisplayParticles()
     ev3dis.type = 6
     ev3.insertAction ev3dis 6
     ageTest.setNextActionList ev3 ageTest
      --------------------------------------------
     
      dis = DisplayParticles()
      dis.color = ev2.wireColor
      dis.type = 6
      ev2.insertAction dis 5
     
     ev2.baseObject.activateAction 5 0
      --ev.type = 3
      --ev.MotionBlur_multiplier = 0.5
      
     pf2.appendInitialActionList ev2
      particleFlow.openParticleView()
      particleFlow.endEdit()
   
   )
fn make_particle1 pnum alen psize= (
         divide_alen = alen/5
         for i in 1 to pnum do(
            b= plane()
            b.length  =psize
            b.width =psize
            rnd1 =  random [-20,-20,-20] [20,20,20]
            rnd2 = random [-100,-100,-100] [100,100,100]
            rnd3 = random [0,0,0] [180,180,180]
            with animate on (
               at time divide_alen b.pos.controller.x_position = rnd1.x
               at time divide_alen b.pos.controller.y_position = rnd1.y
               at time divide_alen b.pos.controller.z_position = rnd1.z
         
               at time alen b.pos.controller.x_position = rnd2.x
               at time alen b.pos.controller.y_position = rnd2.y
               at time alen b.pos.controller.z_position = rnd2.z
               at time alen rotate b (eulerAngles rnd3.x rnd3.y rnd3.z)
            )
         )
      )
   fn make_mist pnum alen psize= (
      particle = superspray()
      particle.quantityMethod = 0
      particle.Birth_Rate = 30
      particle.speed = 1.5
      particle.Emitter_Start = 0f
      particle.Emitter_Stop = alen
      particle.Display_Until = alen
      particle.life = 180
      particle.size = psize
      particle.Size_Variation = 30.0
      particle.growth_Time = alen * 0.3
      particle.Fade_Time = alen * 0.1
      particle.Axis_Spread = 2.0
      particle.particleType = 0
      particle.standardParticle = 3
      
      dragForce = drag()
      dragForce.'time off' = 300
      dragForce.dampingx = 1.0
      dragForce.dampingy = 1.0
      dragForce.dampingz = 1.0
      bindSpaceWarp particle dragForce
      
      windForce = wind()
      windForce.strength = 0.008
      windForce.Turbulence = 0.03
      windForce.Frequency = 0.12
      windForce.baseobject.scale = 0.1
      bindSpaceWarp particle windForce
      
         
      )
   fn make_fire = (
      
      cm = Freecamera()
      cm.position = [0,45.547,307.107]
      cm.fov = 60
      obj = sphere()
      obj.radius = 10
      noiseC = noise_position()
      noiseC.frequency = 0.03
      noiseC.noise_strength = [400,0,30]
      noiseC.fractal = false
      obj.position.controller = noiseC
      
      windForce = wind()
      windForce.windtype = 1
      windForce.strength = -0.2
      windForce.Turbulence = 0.5
      windForce.frequency = 4.0
      windForce.baseobject.scale = 0.1
      windForce.position =[0,0,50]
      linker childName: "Wind001" parentName: "Sphere001"
      
      st = StandardMaterial showInViewport: true
      no = Noise()
      no.type = 2
      no.size = 10
      no.thresholdLow = 0.049
      no.thresholdHigh = 0.05
      no.levels = 1.0
      no.color1 = White
      no.color2 = Black
      st.diffusemap = no
      obj.material = st
      
      pf = PF_source()
      pf.particle_AMount_Limit = 50000000
      pf.Quantity_Viewport = 100
      particleFlow.beginEdit()
      particleFlow.cleanUpParticleFlow false
      rend = RenderParticles()
      pf.insertAction rend 1
      
      ev = Event()
      ev.setPViewLocation 301 305
      bir = Birth()
      ev.insertAction bir 1
      
      posObj = Position_Object()
      ev.insertAction posObj 2
      posObj.Emitter_Objects = #($'Sphere001')
      posObj.Density_By_Emitter_Material = on
      bir.Emit_Start = -4000 -- -25
      bir.Emit_Stop = 48000 -- 300
      bir.amount = 400000 --파티클 개수
      
      forc = Force()
      ev.insertAction forc 3
      forc.Force_Space_Warps = #($'Wind001')
      
      shapeFac =  Shape_Facing()
      ev.insertAction shapeFac 4
      shapeFac.Look_At_Object= cm
      
      matStatic = Material_Static()
      ev.insertAction matStatic 5
      matFire = standardMaterial()
      matFire.opacity = 5
      col = Color 255 188 45
      col.h = 29
      matFire.diffuse = col
      matFire.opacityType = 2
      matStatic.Assigned_Material = matFire
      
      
      delParti =  DeleteParticles()
      ev.insertAction delParti 6
      delParti.type = 2
      delParti.Life_Span = 1280 -- 8
      delParti.variation = 320 --2
      
      dis = DisplayParticles()
      dis.color = ev.wireColor
      dis.type = 6
      ev.insertAction dis 7
      --ev.type = 3
      --ev.MotionBlur_multiplier = 0.5
      
      pf.appendInitialActionList ev
      particleFlow.endEdit()
      
     add_smoke()
      )
  

utility bomb_roll "MAKEPARTICLE"(
   spinner animation_len "애니메이션 길이" range: [0,500,250] type: #integer
   spinner particle_num "파티클 개수" range: [0,500,250] type: #integer
   spinner particle_size "파티클 크기" range: [0,10,5] type: #integer
   button parti1_btn "빵빠레 생성"  
   button parti2_btn "연기 생성"
   button parti3_btn "불 생성"
   button reset_btn "지우기"
   
   on parti1_btn pressed do(
         make_particle1 particle_num.value animation_len.value particle_size.value
      )
   on parti2_btn pressed do(
         make_mist particle_num.value animation_len.value particle_size.value
      )
   on parti3_btn pressed do(
      make_fire()
      )
   on reset_btn pressed do(
      delete objects
      )
   )