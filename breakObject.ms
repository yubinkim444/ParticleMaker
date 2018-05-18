global b
global obj
global count=0
global posit
global plane1
rollout jimitest "Object 추가하기" 
(
    dropdownlist scale_dd "Object" items:#("none","box", "cone", "sphere", "teapot")
     button select_ok "ok" enabled:false
   
   
    button make_plane "평면추가"
    slider plane_height "평면위치 조정"  range:[5,20,10]
    spinner plane_Lseg "평면 lengthseg" range:[1,60,10]
    spinner plane_Wseg "평면 widthseg" range:[1,60,10]
    
    button addnoise "noise 추가" 
    spinner noisestrength "noisestrength" range:[0,80,0] enabled:false
    spinner noiserough "noise표면" range:[0,0.3,0] enabled:false
   
   button cutter "평면 나머지 부분 자르기" 

   button detach "분리"
   
    on scale_dd selected i do
    (
       b= scale_dd.items[i] as string
       format "You selected '%'!\n" scale_dd.items[i]
       count+=1
       select_ok.enabled=true

    )
     
    
   on select_ok pressed do
   (
      if b=="box" then
         obj=box()
      else if b=="cone" then
         obj=cone()
      else if b=="sphere" then
         obj=sphere()
      else if b=="teapot" then
         obj=teapot()
      
      if count==1 then
         select_ok.enabled=false
   )
   
   on make_plane pressed do
   (
      posit=obj.position
      plane1=plane pos:posit width:60 length:60
      
   )
   
   on plane_height changed val do
   (
      plane1.pos.z=val
   )
   
   on plane_Lseg changed val do
   (
      plane1.lengthsegs=val
   )
   
      on plane_Wseg changed val do
   (
      plane1.widthsegs=val
   )
   
   on addnoise pressed do
   (
      
      addmodifier plane1 (Noisemodifier ())
      plane1.noise.fractal=on
      noisestrength.enabled=true
      noiserough.enabled=true

   )
   
   on noisestrength changed val do
   (
      plane1.noise.strength.z=val
   )
   
   on noiserough changed val do
   (
      plane1.noise.roughness=val
   )
   
   on cutter pressed do 
   (
      ProCutter.CreateCutter #(plane1) 4 true true false true true
      ProCutter.addStocks plane1 #(obj) 1 1 

   )
   
   on detach pressed do 
   (
      select plane1   
      addmodifier plane1 (Edit_Poly ())
      messagebox "select->element 한 후 원하는 부분을 선택한 다음 detach를 눌러주세요."
      
         
   )
   
   
)
createdialog jimitest