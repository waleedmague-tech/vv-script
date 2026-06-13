-- VV Ultimatum — FULL shareable build. Bakes in the author's settings + parry
-- timings + learned attack stats. On first load it writes them into your
-- executor workspace (backing up any existing copy to *.vvbak) so you get the
-- author's EXACT setup, then the script runs normally.
do
  local function seed(name, data)
    pcall(function()
      if isfile and isfile(name) and readfile(name) ~= data then
        pcall(function() writefile(name .. ".vvbak", readfile(name)) end)
      end
      writefile(name, data)
    end)
  end
  seed("settings.json", [[
{"state__FacingPredict":false,"state__ESPSplitFrames":16,"state__RepeatOnMiss":false,"state__PlayerTiming":false,"state__ESPRange":1161,"state__TTBSticky":true,"state__ParryNearestOnly":false,"state__RepeatOnMissMax":1,"menu_size":{"w":1094.4000244140625,"h":854.4000244140625},"state__ESPName":true,"state__SmartHitWindow":0.4,"state__ESPWeapon":true,"state__SpySelf":true,"state__LowGfx":false,"proj_autoadd":false,"ui_scale":1.19,"state__ESPNPCs":false,"state__TTBDistance":0,"state__ESPStamina":false,"state__NoFog":false,"state__ESPMaxTargets":0,"state__ProjDebug":false,"state__NoAnimatedSea":false,"state__APBreakerSpeed":6,"accent_name":"Purple","state__HitboxParryDelay":0,"state__ESPOutline":true,"state__HitboxAutoDetect":false,"state__FeintWindow":0.25,"state__PlayerTimingProjDist":80,"state__PingCompStrength":100,"state__HighPing":true,"state__ESP":true,"state__PlayerTimingRange":80,"state__ESPMobs":true,"state__NotifSafety":true,"state__ESPBox":false,"state__Fullbright":false,"state__AnimVizRange":100,"state__HitboxHistory":true,"menu_visible":false,"profiles":{"default":{"state__FacingPredict":true,"state__RepeatOnMiss":false,"state__PlayerTiming":false,"state__AnimVizRange":100,"state__TTBSticky":true,"state__ParryNearestOnly":false,"state__RepeatOnMissMax":3,"state__ESPName":true,"state__SmartHitWindow":0.5,"state__ESPWeapon":true,"state__SpySelf":true,"state__LowGfx":true,"state__ESPNPCs":false,"state__PlayerTimingRange":80,"state__ESPStamina":false,"state__NoAnimatedSea":false,"state__ESPOutline":true,"state__ESP":true,"state__ESPMobs":true,"state__NotifSafety":true,"state__NoShadows":false,"state__AutoParry":true,"state__ESPPosture":false,"state__HitboxRangeParry":true,"state__ESPLimitUpdates":false,"state__ESPPlayers":true,"state__SpyEnemies":true,"state__APBreakerSpeed":10,"state__ModeratorChecker":true,"state__Debug":true,"state__SmartHit":true,"state__ESPSplitUpdates":false,"state__ToggleSprint":false,"state__ESPBox":false,"state__APBreaker":true,"state__HitboxSize":14,"state__NoFog":false,"state__TweenToBack":false,"state__Noclip":false,"state__HitboxRangeDodge":false,"state__ESPTextScale":116,"state__HitboxParryRange":13,"state__SpyPaused":false,"state__ESPSplitHealth":true,"state__HitboxRangeMode":true,"state__ESPBoxBar":false,"state__NoBlur":false,"state__HitboxHistory":true,"state__HitboxDodgeRange":34,"state__NotificationsEnabled":true,"state__Spyware":false,"state__ParryWhenUnfocused":true,"state__HitboxParryDelay":0.04,"state__DetectionRange":35,"state__ParryMobsOnly":false,"state__TTBRange":20,"state__ESPDistance":true,"state__NotifToggles":true,"state__AutoParryRange":20,"state__AutoFeintType":"Passive","state__HitboxReach":14,"state__Fly":false,"state__ESPNameScale":89,"state__AutoDodge":true,"state__ParryFacingMe":false,"state__BlockHold":0.303,"state__TTBHeight":8,"state__ESPHealth":true,"state__YouTuberChecker":true,"state__KeybindHud":true,"state__Feint":false,"state__ESPStates":false,"state__FlySpeed":148,"state__ESPHitbox":false,"state__Fullbright":false,"state__ESPRange":1531,"state__ESPReiatsu":false,"state__HitboxPredict":true,"state__FeintWindow":0.25,"state__TTBDistance":0,"state__NoPersistentESP":false,"state__TimingOffset":0,"state__ESPRaceForm":false,"state__StreamProof":false},"More fps":{"state__ESPStamina":false,"state__ESPLimitUpdates":true,"state__ESPMaxTargets":12,"state__ESPPlayers":true,"state__NoAnimatedSea":true,"state__NoFog":true,"state__ESPOutline":false,"state__ESPRange":300,"state__ESPSplitUpdates":true,"state__ESPSplitFrames":4,"state__ESPRaceForm":false,"state__ESP":true,"state__ESPHealth":true,"state__ESPMobs":true,"state__ESPDistance":true,"state__ESPName":true,"state__ESPReiatsu":false,"state__ESPRefreshRate":15,"state__ESPWeapon":false,"state__Fullbright":false,"state__LowGfx":true,"state__NoShadows":true,"state__ESPPosture":false,"state__NoBlur":true,"state__ESPNPCs":true,"state__NoPersistentESP":true,"state__ESPStates":false,"state__ESPHitbox":false,"state__ESPBox":false}},"state__NoShadows":false,"state__StreamProof":false,"state__KeybindHud":true,"state__YouTuberChecker":true,"state__AutoParry":true,"av_size":{"w":1400,"h":899},"state__ESPPosture":false,"state__HitboxRangeParry":true,"menu_pos":{"y":4,"x":231},"state__ESPLimitUpdates":false,"state__SmartHit":false,"state__ESPPlayers":true,"state__SpyEnemies":true,"keybinds":{"toggle_esp":"J","toggle_fly":"F6","toggle_sprint":"F5","toggle_visualizer":"F4","toggle_ttb":false,"toggle_autoparry":"Minus","toggle_noclip":"LeftBracket","panic_hide":"PageDown","toggle_menu":"F1"},"state__HitboxMinDist":10,"state__ParryPlayersOnly":false,"state__NotificationsEnabled":true,"state__Debug":false,"state__Feint":false,"state__ESPSplitUpdates":false,"state__ToggleSprint":false,"state__ModeratorChecker":true,"state__AutoDodge":true,"state__HitboxSize":14,"state__HitboxPredict":true,"last_tab":"Projectiles","state__ESPReiatsu":false,"state__HitboxRangeDodge":true,"state__BlockHold":0.3,"kbhud_pos":{"y":244,"x":1753},"state__SpyPaused":false,"state__ESPSplitHealth":true,"state__HitboxRangeMode":true,"hitbox_anims":{"107291226944821":true,"107507023089925":true,"93437441193278":true,"102383192983641":true},"state__NoBlur":false,"state__ESPTextScale":104,"state__Spyware":false,"state__FlySpeed":122,"state__ESPHitbox":false,"proj_scan_ws":false,"av_blacklist":{"103172511870517":true,"125759237459844":true,"14085268099":true,"79911812747670":true,"80044202039051":true,"18958401014":true,"12340126947":true,"116142638412795":true,"14410995942":true,"84011433093848":true,"72997946136762":true,"121360312698048":true,"17096542398":true,"14580994889":true,"14040639604":true,"14597046093":true,"9684147213":true,"6748146529":true,"121073694203767":true,"100897282827156":true,"14040016097":true,"9465902304":true,"14629341894":true,"18703240654":true,"14411175349":true,"85671320882552":true,"128832412932473":true,"9727223016":true,"104242396518430":true,"14629239924":true,"14039986255":true,"108088498534310":true,"120278948965320":true,"99293053680886":true,"11497886799":true,"106688736282435":true,"10569718648":true,"9461063984":true,"15562373643":true,"14411040819":true,"14040195659":true,"13959318029":true,"17732076730":true,"14411249478":true,"91276593220093":true,"132341402302737":true,"14089462130":true,"18958341833":true,"14326715025":true,"6940137765":true,"13840481766":true,"127153082609965":true,"140098173852774":true,"13966232587":true,"14089013549":true,"104764556635506":true,"71081429380094":true,"14326709511":true,"17097895421":true,"135179392622334":true,"81892426176032":true,"18687801845":true,"116326573759959":true,"88824029979745":true,"18998838518":true,"14040644420":true,"101162579246421":true,"77594694343908":true,"134944919039812":true,"104296721489281":true,"94934451271455":true,"140067530156353":true,"14326697801":true,"11273001982":true,"95489610864558":true,"82527686698091":true,"131471465669923":true,"115140436410496":true,"14088984049":true,"18958397073":true,"84008666719547":true,"18824220938":true,"9465728971":true,"119744649456014":true,"14629324978":true,"126212171075042":true,"110047877378582":true,"14089528068":true,"137805914141039":true,"89799250368182":true,"14628609085":true,"113631162072406":true,"11113399244":true,"17188146433":true,"11385505343":true,"103245462113802":true,"14035436505":true,"93674214784193":true,"13967197291":true,"14699824274":true,"107848116205888":true,"136733734909381":true,"95156323937837":true,"14326970837":true,"18983643529":true,"17150093453":true,"72516337412467":true,"17150065294":true,"108328830898212":true,"86195378216296":true,"6954017051":true,"91064180025830":true,"73529457986066":true,"70967133952711":true,"9461059177":true,"109817071639480":true,"18998824329":true,"18429789282":true,"14089521212":true,"108597439219369":true,"17096539206":true,"17188155225":true,"6748003806":true,"14629506290":true,"17138943090":true,"80804878487892":true,"14629233116":true,"11497901053":true,"17188140730":true,"14565029673":true,"78841924930006":true,"100337363686814":true,"17150081722":true,"15545518166":true,"17138937724":true,"124584954720477":true,"121559768488375":true,"10179130615":true,"119664184440710":true},"state__DetectionRange":11,"state__ParryMobsOnly":false,"state__TTBRange":20,"state__ESPDistance":true,"av_pos":{"y":105,"x":234},"state__AutoParryRange":20,"state__Fly":false,"state__HitboxReach":14,"state__PingComp":true,"state__ESPNameScale":66,"state__ESPStates":false,"state__ParryFacingMe":false,"state__DelayedFeints":false,"state__TTBHeight":8,"state__ESPHealth":true,"state__AutoFeintType":"Passive","state__NotifToggles":true,"state__ParryWhenUnfocused":true,"projectile_names":{"SlidingFX":true,"QuincyArrowProjectile":{"d":75},"SpitShot":true,"Bubble":true,"FireEffect1":{"d":75},"White":true,"Projectile2":true,"FingerCeroEffect":{"d":50},"Red":true},"state__HitboxDodgeRange":25,"state__HitboxParryRange":80,"state__ESPBoxBar":false,"state__Noclip":false,"state__HitboxMaxDist":0,"theme":"Black","state__TweenToBack":false,"state__APBreaker":false,"state__NoPersistentESP":false,"state__TimingOffset":0,"state__ESPRaceForm":false,"state__MeasureOnHit":false}
]])
  seed("parrytimings.json", [[
{"102209137660745":{"src":"manual","cat":"Centipede","times":[0.45850059390068056],"sec":0.45850059390068056,"dodges":[]},"105056646850750":{"src":"manual","cat":"fist","times":[0.4504299759864807],"sec":0.4504299759864807,"dodges":[]},"82920555618504":{"src":"manual","cat":"Trailer Boss","times":[0.3508268892765045],"sec":0.3508268892765045,"dodges":[]},"17086023674":{"src":"manual","cat":"bow","times":[0.5910009741783142],"sec":0.5910009741783142,"dodges":[]},"17188386684":{"src":"manual","cat":"scorpion","times":[0.67119961977005],"sec":0.67119961977005,"dodges":[]},"81841736775961":{"src":"manual","cat":"peng","times":[1.3565810918807984],"sec":1.3565810918807984,"dodges":[]},"87577652741355":{"src":"manual","cat":"mt","times":[0.5642522573471069],"sec":0.5642522573471069,"dodges":[]},"84523300592719":{"src":"manual","cat":"peng","times":[0.5006682276725769],"sec":0.5006682276725769,"dodges":[]},"11151794033":{"src":"manual","cat":"Rapier","times":[0.4851875901222229,0.5729460716247559,0.6899574398994446],"sec":0.4851875901222229,"dodges":[]},"11361552631":{"src":"manual","cat":"Rapier","times":[0.5250533223152161],"sec":0.5250533223152161,"dodges":[]},"96681964533604":{"src":"manual","cat":"hammer","times":[1.905636191368103],"sec":1.905636191368103,"dodges":[]},"101464977033970":{"src":"manual","cat":"Centipede","times":[0],"sec":0,"dodges":[]},"17188670401":{"src":"manual","cat":"scorpion","times":[0.4805253744125366,0.9817593097686768,1.5027787685394288],"sec":0.4805253744125366,"dodges":[]},"139167828097095":{"src":"manual","cat":"monkey","times":[1.2184077501296998,2.750192403793335],"sec":1.2184077501296998,"dodges":[]},"107507023089925":{"src":"manual","cat":"Other","times":[0.7708030343055725],"sec":0.7708030343055725,"dodges":[]},"107574429239718":{"src":"manual","cat":"dragonfly","times":[1.086485743522644],"sec":1.086485743522644,"dodges":[]},"6950979119":{"src":"manual","cat":"kido","times":[0.6009315848350525],"sec":0.6009315848350525,"dodges":[]},"14040288114":{"src":"manual","cat":"lizard","times":[0.5300281643867493],"sec":0.5300281643867493,"dodges":[]},"91983451624365":{"src":"manual","cat":"mt","times":[0.504865825176239],"sec":0.504865825176239,"dodges":[0.6117184162139893]},"71416929825712":{"src":"manual","cat":"spider","times":[0.8108673691749573],"sec":0.8108673691749573,"dodges":[]},"76754008387126":{"src":"manual","cat":"Katana","times":[0.5019468665122986],"sec":0.5019468665122986,"dodges":[]},"17154399253":{"src":"manual","cat":"mt","times":[0.4783104956150055],"sec":0.4783104956150055,"dodges":[]},"86509163598473":{"src":"manual","cat":"king","times":[],"dodges":[0.4513448178768158]},"140223371973489":{"src":"manual","cat":"peng","times":[0.7507491111755371],"sec":0.7507491111755371,"dodges":[]},"14089285097":{"src":"manual","cat":"gorilla","times":[],"dodges":[0.6503385305404663]},"17413093522":{"src":"manual","cat":"mt","times":[],"dodges":[0.956620991230011,0.9725770950317383]},"93604577018528":{"src":"manual","cat":"greataxe","times":[0.5524000525474548],"sec":0.5524000525474548,"dodges":[]},"13854505129":{"src":"manual","cat":"clone","times":[0.691128671169281],"sec":0.691128671169281,"dodges":[]},"96020812931018":{"src":"manual","cat":"hakuda","times":[0.6805752515792847],"sec":0.6805752515792847,"dodges":[]},"134801845956597":{"src":"manual","cat":"bear","times":[0.5491747260093689],"sec":0.5491747260093689,"dodges":[]},"79441716695622":{"src":"manual","cat":"SmallFly","times":[0.38420140743255618],"sec":0.38420140743255618,"dodges":[]},"135906726244054":{"src":"manual","cat":"Club","times":[0.6144373416900635],"sec":0.6144373416900635,"dodges":[]},"126037393769736":{"src":"manual","cat":"Katana","times":[1.6834359169006348],"sec":1.6834359169006348,"dodges":[]},"17086024936":{"src":"manual","cat":"bow","times":[0.5910009741783142],"sec":0.5910009741783142,"dodges":[]},"14040293266":{"src":"manual","cat":"lizard","times":[0.4790174663066864],"sec":0.4790174663066864,"dodges":[]},"107439297045997":{"src":"manual","cat":"fist","times":[0.7780616879463196],"sec":0.7780616879463196,"dodges":[]},"74973280679545":{"src":"manual","cat":"Katana","times":[0.5019468665122986],"sec":0.5019468665122986,"dodges":[]},"17154401086":{"src":"manual","cat":"mt","times":[0.47166213393211367],"sec":0.47166213393211367,"dodges":[]},"17429351656":{"src":"manual","cat":"mt","times":[0.4669221043586731],"sec":0.4669221043586731,"dodges":[]},"98693595418815":{"src":"manual","cat":"clt","times":[0.25231316685676577,1.8013836145401],"sec":0.25231316685676577,"dodges":[]},"76447568872156":{"src":"manual","cat":"greataxe","times":[0.5763341784477234],"sec":0.5763341784477234,"dodges":[]},"83478022548253":{"src":"manual","cat":"Trailer Boss","times":[1.092726469039917],"sec":1.092726469039917,"dodges":[]},"74564651506542":{"src":"manual","cat":"Bat","times":[0.5624491572380066,0.7609904408454895],"sec":0.5624491572380066,"dodges":[]},"11130826551":{"src":"manual","cat":"Trailer Boss","times":[0.9213452339172363],"sec":0.9213452339172363,"dodges":[]},"15560352579":{"src":"manual","cat":"ninja","times":[0.48449939489364626,0.6724621057510376],"sec":0.48449939489364626,"dodges":[]},"11361791134":{"src":"manual","cat":"Rapier","times":[0.5536381602287293],"sec":0.5536381602287293,"dodges":[]},"80960587783764":{"src":"manual","cat":"hakuda","times":[0.4504299759864807],"sec":0.4504299759864807,"dodges":[]},"17150208141":{"src":"manual","cat":"mantis","times":[],"dodges":[0.6007954478263855]},"131948862232554":{"src":"manual","cat":"spear","times":[0.44588279724121096,0.8280326724052429],"sec":0.44588279724121096,"dodges":[]},"109175080835575":{"src":"manual","cat":"Club","times":[0.6192241311073303],"sec":0.6192241311073303,"dodges":[]},"98238404943510":{"src":"manual","cat":"bear","times":[0.3717014789581299],"sec":0.3717014789581299,"dodges":[]},"86850231217100":{"src":"manual","cat":"toad","times":[0.4505181908607483],"sec":0.4505181908607483,"dodges":[]},"115495827589598":{"src":"manual","cat":"dragonfly","times":[1.295290470123291,1.8052470684051514],"sec":1.295290470123291,"dodges":[]},"122823331494331":{"src":"manual","cat":"Crocodile","times":[0.5504661202430725],"sec":0.5504661202430725,"dodges":[]},"127367360034401":{"src":"manual","cat":"toad","times":[0.6106715798377991],"sec":0.6106715798377991,"dodges":[]},"81281779521042":{"src":"manual","cat":"Club","times":[0.638371467590332],"sec":0.638371467590332,"dodges":[]},"111458184388856":{"src":"manual","cat":"spear","times":[0.39935043454170229],"sec":0.39935043454170229,"dodges":[]},"11361697224":{"src":"manual","cat":"Rapier","times":[0.5154456496238709],"sec":0.5154456496238709,"dodges":[]},"123458031797396":{"src":"manual","cat":"kick","times":[0.4894053339958191],"sec":0.4894053339958191,"dodges":[]},"91370102211257":{"src":"manual","cat":"Trailer Boss","times":[0.3324633538722992],"sec":0.3324633538722992,"dodges":[]},"11123981295":{"src":"manual","cat":"spear","times":[0.723741888999939,1.3586612939834595],"sec":0.723741888999939,"dodges":[]},"17891413295":{"src":"manual","cat":"mt","times":[0.4836291968822479],"sec":0.4836291968822479,"dodges":[]},"80503383167824":{"src":"manual","cat":"monkey","times":[0.530161440372467],"sec":0.530161440372467,"dodges":[]},"94860056861084":{"src":"manual","cat":"Katana","times":[0.7015480399131775],"sec":0.7015480399131775,"dodges":[]},"14110194908":{"src":"manual","cat":"menos","times":[1.0630077123641968],"sec":1.0630077123641968,"dodges":[]},"17891409381":{"src":"manual","cat":"mt","times":[0.49027755856513979],"sec":0.49027755856513979,"dodges":[]},"113101872248044":{"src":"manual","cat":"flash","times":[0.9040733575820923],"sec":0.9040733575820923,"dodges":[]},"110620209403887":{"src":"manual","cat":"Crocodile","times":[0.5504661202430725],"sec":0.5504661202430725,"dodges":[]},"118172369009535":{"src":"manual","cat":"Rifle","times":[0.7271672487258911],"sec":0.7271672487258911,"dodges":[]},"85599301703737":{"src":"manual","cat":"scythe","times":[0.4562678039073944],"sec":0.4562678039073944,"dodges":[]},"103319060602038":{"src":"manual","cat":"greataxe","times":[0.578993558883667],"sec":0.578993558883667,"dodges":[]},"14024378591":{"src":"manual","cat":"Rifle","times":[1.0116331577301026],"sec":1.0116331577301026,"dodges":[]},"128875759494501":{"src":"manual","cat":"Other","times":[1.5468348264694214],"sec":1.5468348264694214,"dodges":[]},"14110203809":{"src":"manual","cat":"menos","times":[1.0717037916183472],"sec":1.0717037916183472,"dodges":[]},"138644029603579":{"src":"manual","cat":"panther","times":[1.245976209640503],"sec":1.245976209640503,"dodges":[]},"106707347714801":{"src":"manual","cat":"Crocodile","times":[],"dodges":[1.1289597749710084]},"130821883699985":{"src":"manual","cat":"panther","times":[0.4709728956222534],"sec":0.4709728956222534,"dodges":[]},"101892073899926":{"src":"manual","cat":"king","times":[0.5622162818908691],"sec":0.5622162818908691,"dodges":[]},"105242552416030":{"src":"manual","cat":"fist","times":[0.44192007184028628],"sec":0.44192007184028628,"dodges":[]},"124281421943100":{"src":"manual","cat":"monkey","times":[0.8026237487792969,1.690580129623413,2.4054129123687746],"sec":0.8026237487792969,"dodges":[]},"9780037814":{"src":"manual","cat":"ninja","times":[0.9495152235031128],"sec":0.9495152235031128,"dodges":[]},"132052485145774":{"src":"manual","cat":"Trailer Boss","times":[0.9136906862258911],"sec":0.9136906862258911,"dodges":[]},"16417792446":{"src":"manual","cat":"Rifle","times":[0,0.5014553666114807],"sec":0,"dodges":[]},"130053309887427":{"src":"manual","cat":"mt","times":[0.6437327861785889,0.9564721584320068,1.1479451656341553],"sec":0.6437327861785889,"dodges":[]},"129343427417751":{"src":"manual","cat":"peng","times":[0.7538895606994629,1.4022387266159058,2.326840877532959],"sec":0.7538895606994629,"dodges":[]},"17086022325":{"src":"manual","cat":"bow","times":[0.5910009741783142],"sec":0.5910009741783142,"dodges":[]},"79069029683112":{"src":"manual","cat":"mt","times":[0.6609420776367188],"sec":0.6609420776367188,"dodges":[]},"17819993121":{"src":"manual","cat":"scythe","times":[0.5471472144126892],"sec":0.5471472144126892,"dodges":[]},"89900583582792":{"src":"manual","cat":"panther","times":[0.8307188749313355],"sec":0.8307188749313355,"dodges":[]},"115880291306156":{"src":"manual","cat":"hammer","times":[0.7529203295707703],"sec":0.7529203295707703,"dodges":[]},"131177999571320":{"src":"manual","cat":"bear","times":[2.7486090660095217],"sec":2.7486090660095217,"dodges":[]},"130863537121533":{"src":"manual","cat":"scythe","times":[0.45371484756469729],"sec":0.45371484756469729,"dodges":[]},"17759824327":{"src":"manual","cat":"greataxe","times":[0.6326465010643005,1.277591586112976],"sec":0.6326465010643005,"dodges":[]},"72352073483435":{"src":"manual","cat":"Katana","times":[0.5285711884498596],"sec":0.5285711884498596,"dodges":[]},"74701342732989":{"src":"manual","cat":"bear","times":[0.5532169342041016],"sec":0.5532169342041016,"dodges":[]},"111873467408104":{"src":"manual","cat":"panther","times":[0.4709728956222534],"sec":0.4709728956222534,"dodges":[]},"122969699986265":{"src":"manual","cat":"king","times":[0.5622162818908691],"sec":0.5622162818908691,"dodges":[]},"11361464104":{"src":"manual","cat":"Rapier","times":[0.5310028195381165],"sec":0.5310028195381165,"dodges":[]},"95215940936364":{"src":"manual","cat":"ninja","times":[0],"sec":0,"dodges":[]},"16932406623":{"src":"manual","cat":"flash","times":[1.0715346336364747],"sec":1.0715346336364747,"dodges":[]},"107291226944821":{"src":"manual","cat":"Other","times":[0.15279577672481538],"sec":0.15279577672481538,"dodges":[]},"83097070172817":{"src":"manual","cat":"dragonfly","times":[],"dodges":[1.3212469816207886]},"14089180282":{"src":"manual","cat":"gorilla","times":[0.6003831624984741],"sec":0.6003831624984741,"dodges":[]},"101485195772910":{"src":"manual","cat":"SmallFly","times":[0.455568790435791],"sec":0.455568790435791,"dodges":[]},"91983784248298":{"src":"manual","cat":"scythe","times":[0.45116186141967776],"sec":0.45116186141967776,"dodges":[]},"17732755849":{"src":"manual","cat":"lance","times":[0.6626757979393005],"sec":0.6626757979393005,"dodges":[]},"104694319353269":{"src":"manual","cat":"fist","times":[0.4504299759864807],"sec":0.4504299759864807,"dodges":[]},"14327026699":{"src":"manual","cat":"turtle","times":[0.6490175127983093,1.9041235446929932],"sec":0.6490175127983093,"dodges":[]},"83974667129266":{"src":"manual","cat":"scythe","times":[0.45116186141967776],"sec":0.45116186141967776,"dodges":[]},"11121384790":{"src":"manual","cat":"hammer","times":[1.2413607835769654],"sec":1.2413607835769654,"dodges":[]},"119744649456014":{"src":"manual","cat":"Katana","times":[0.6356058120727539],"sec":0.6356058120727539,"dodges":[]},"93227313880429":{"src":"manual","cat":"clt","times":[1.9076576232910157],"sec":1.9076576232910157,"dodges":[]},"14628756235":{"src":"manual","cat":"Centipede","times":[],"dodges":[2.000256061553955]},"90883933480570":{"src":"manual","cat":"Centipede","times":[0.46086740493774416],"sec":0.46086740493774416,"dodges":[]},"17139363450":{"src":"manual","cat":"spider","times":[],"dodges":[1.6204625368118287]},"82358037666428":{"src":"manual","cat":"mt","times":[0.6505236029624939],"sec":0.6505236029624939,"dodges":[]},"126131534219589":{"src":"manual","cat":"toad","times":[0.9528053402900696],"sec":0.9528053402900696,"dodges":[]},"85733968676546":{"src":"manual","cat":"Crocodile","times":[1.0595581531524659,1.6532843112945557,2.4027416706085207],"sec":1.0595581531524659,"dodges":[]},"95990465493386":{"src":"manual","cat":"spider","times":[0.7813252210617065],"sec":0.7813252210617065,"dodges":[]},"91233168287060":{"src":"manual","cat":"Katana","times":[0.528274416923523],"sec":0.528274416923523,"dodges":[]},"118925530415750":{"src":"manual","cat":"spear","times":[0.5355291366577148],"sec":0.5355291366577148,"dodges":[]},"18697609875":{"src":"manual","cat":"Trailer Boss","times":[],"dodges":[0.603553295135498]},"139926815993252":{"src":"manual","cat":"Katana","times":[0.7351464033126831,1.4807212352752686],"sec":0.7351464033126831,"dodges":[]},"115338865375824":{"src":"manual","cat":"hammer","times":[0.7708709239959717],"sec":0.7708709239959717,"dodges":[]},"16417788544":{"src":"manual","cat":"Rifle","times":[0.470860093832016],"sec":0.470860093832016,"dodges":[]},"96040009026472":{"src":"manual","cat":"SmallFly","times":[0.4270218312740326],"sec":0.4270218312740326,"dodges":[]},"17188289743":{"src":"manual","cat":"scorpion","times":[],"dodges":[0.03181049972772598]},"17429347710":{"src":"manual","cat":"mt","times":[0.49143898487091067,0.8350134491920471],"sec":0.49143898487091067,"dodges":[]},"14089184318":{"src":"manual","cat":"gorilla","times":[0.6003831624984741],"sec":0.6003831624984741,"dodges":[]},"17150117745":{"src":"manual","cat":"mantis","times":[0.4378150701522827],"sec":0.4378150701522827,"dodges":[]},"75729004732047":{"src":"manual","cat":"ninja","times":[1.770024299621582],"sec":1.770024299621582,"dodges":[1.6795001029968262]},"17150140878":{"src":"manual","cat":"mantis","times":[0.4667062759399414],"sec":0.4667062759399414,"dodges":[]},"13831954897":{"src":"manual","cat":"scythe","times":[0.44316035509109499],"sec":0.44316035509109499,"dodges":[]},"14327924170":{"src":"manual","cat":"turtle","times":[0.6003831624984741],"sec":0.6003831624984741,"dodges":[]},"134281749755415":{"src":"manual","cat":"monkey","times":[0.5301156640052795],"sec":0.5301156640052795,"dodges":[]},"78020267794128":{"src":"manual","cat":"Trailer Boss","times":[0.6532840728759766],"sec":0.6532840728759766,"dodges":[]},"17384025359":{"src":"manual","cat":"Rifle","times":[0.6527319550514221],"sec":0.6527319550514221,"dodges":[]},"85652792138826":{"src":"manual","cat":"Trailer Boss","times":[0.813636302947998],"sec":0.813636302947998,"dodges":[]},"121072695683680":{"src":"manual","cat":"spear","times":[0.5182737708091736],"sec":0.5182737708091736,"dodges":[]},"16417798771":{"src":"manual","cat":"Rifle","times":[0.5012766718864441],"sec":0.5012766718864441,"dodges":[]},"14327905929":{"src":"manual","cat":"turtle","times":[0.5982291102409363],"sec":0.5982291102409363,"dodges":[]},"13959320065":{"src":"manual","cat":"Rifle","times":[0.33772099018096926],"sec":0.33772099018096926,"dodges":[]},"16417803802":{"src":"manual","cat":"Rifle","times":[0,0.5476216673851013],"sec":0,"dodges":[]},"119333842262474":{"src":"manual","cat":"hammer","times":[0.8319029808044434],"sec":0.8319029808044434,"dodges":[]},"91608694318547":{"src":"manual","cat":"lizard","times":[0.6623438596725464],"sec":0.6623438596725464,"dodges":[]},"102813187141061":{"src":"manual","cat":"Katana","times":[0.37548747658729555,0.952353298664093],"sec":0.37548747658729555,"dodges":[]},"17188382622":{"src":"manual","cat":"scorpion","times":[0.6719962954521179],"sec":0.6719962954521179,"dodges":[]},"13854280230":{"src":"manual","cat":"clone","times":[0.172341987490654],"sec":0.172341987490654,"dodges":[]},"93437441193278":{"src":"manual","cat":"Bat","times":[1.0018298625946046],"sec":1.0018298625946046,"dodges":[]},"17732749500":{"src":"manual","cat":"lance","times":[0.6787914037704468],"sec":0.6787914037704468,"dodges":[]}}
]])
  seed("__autoparry.json", [[
{"17810687654":{"plays":23,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.687226399998,"sum":0,"kfImpact":3.5100000619888309},"105056646850750":{"last":0.17027210000378546,"sumD":159.6113622188568,"sumI":12.599219899996115,"sumDI":60.770171715935649,"kfImpact":0.8666666924953461,"plays":3791,"deaths":0,"cancels":0,"conf":31,"max":0.8235219000052894,"sumDD":1103.3920429666449,"slope":-0.014560429974912646,"intercept":0.4813945149285225,"min":0,"avg":0.40642644838697147,"sum":12.599219899996115,"misses":0,"ema":0.40871951055979435,"kfTimestamp":10716.485596999999,"distAvg":5.148753619963123,"samples":31},"101685564886467":{"plays":239,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.733010199998,"sum":0,"kfImpact":3.25},"18236080952":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.421055400002,"sum":0,"kfImpact":0.8125},"82920555618504":{"plays":57,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"134719303468496":{"plays":523,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.549112599998,"sum":0,"kfImpact":2.708333230018616},"17269260858":{"plays":115,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"140000705413331":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14824880684":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.587789999998,"sum":0,"kfImpact":0.3683333307504654},"17733844200":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"15599736225":{"last":0.070760299999165,"sumD":29.837217330932618,"sumI":0.070760299999165,"sumDI":2.1112904494770774,"plays":736,"deaths":0,"conf":1,"max":0.070760299999165,"samples":1,"distAvg":29.837217330932618,"min":0,"cancels":0,"sumDD":890.2595380533057,"ema":0.070760299999165,"misses":0,"avg":0.070760299999165,"sum":0.070760299999165},"81841736775961":{"last":0.9146824999770615,"sumD":7.259000301361084,"sumI":0.9146824999770615,"sumDI":6.639680542983199,"plays":26,"deaths":0,"conf":1,"max":0.9146824999770615,"samples":1,"distAvg":7.259000301361084,"misses":0,"avg":0.9146824999770615,"sumDD":52.69308537516031,"ema":0.9146824999770615,"min":0,"sum":0.9146824999770615,"cancels":0},"137277278515208":{"plays":93,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"121360312698048":{"last":2.1119725000025939,"sumD":218.11155557632447,"sumI":32.97726259999126,"sumDI":336.96638314295077,"plays":2457,"deaths":0,"conf":24,"max":2.912922499999695,"samples":24,"distAvg":9.087981482346854,"intercept":1.1295586591193534,"min":0,"sum":32.97726259999126,"cancels":0,"avg":1.3740526083329694,"misses":0,"ema":1.5019123699221282,"sumDD":3367.5275263359665,"slope":0.026902998172755805},"80852969321053":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"140290004738395":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.658473999996,"sum":0,"kfImpact":3.1741665840148927},"71344941441736":{"last":0.13450519999605604,"sumD":344.1391305923462,"sumI":9.734432599994762,"sumDI":244.20862315115626,"plays":265,"deaths":0,"conf":13,"max":1.7108712000044762,"samples":13,"distAvg":26.47224081479586,"intercept":1.8057860399190953,"min":0,"slope":-0.03992799625925212,"sum":9.734432599994762,"sumDD":9447.832348335898,"ema":0.6001172518302597,"misses":0,"avg":0.7488025076919047,"cancels":0},"82282249582049":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.312711500002,"sum":0,"kfImpact":1.2891666769981385},"110468627764508":{"last":0.12360370000533294,"sumD":3.943373680114746,"sumI":0.12360370000533294,"sumDI":0.4874155773658288,"plays":446,"deaths":0,"conf":1,"max":0.12360370000533294,"samples":1,"distAvg":3.943373680114746,"min":0,"cancels":0,"sum":0.12360370000533294,"avg":0.12360370000533294,"misses":0,"ema":0.12360370000533294,"sumDD":15.550195981021716},"83904781740173":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.105761699997,"sum":0,"kfImpact":2.166666615009308},"17377962445":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.212516599997,"sum":0,"kfImpact":1.5925000309944153},"15513020295":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17188670401":{"last":0.9888626000029035,"sumD":1580.092040002346,"sumI":94.29425479994507,"sumDI":976.3476005062565,"plays":979,"deaths":2,"conf":159,"max":1.1541674999971293,"samples":153,"distAvg":10.3273989542637,"intercept":0.6116471367763575,"min":0,"slope":0.00045076037036507333,"sum":94.29425479994507,"sumDD":21938.105134882815,"ema":0.7650797541073369,"misses":0,"avg":0.6163023189538893,"cancels":0},"11254945591":{"plays":191,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.062860699996,"sum":0,"kfImpact":2.2641666769981385},"129971736651477":{"plays":11,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"107574429239718":{"last":1.2207667999973638,"sumD":10.272541999816895,"sumI":2.5490843999978098,"sumDI":13.065158548679137,"plays":737,"deaths":0,"conf":2,"max":1.328317600000446,"samples":2,"distAvg":5.136270999908447,"min":0,"cancels":0,"sum":2.5490843999978098,"avg":1.2745421999989049,"misses":0,"ema":1.2960523599995213,"sumDD":52.89455412809275},"9465902304":{"last":0.30560360000527,"combo":{"18998838518":{"samples":2,"sum":0.9678525999988779,"avg":0.4839262999994389}},"cancelRate":0.06666666666666667,"sumD":180.44325053691865,"sumI":5.646177600013289,"sumDI":52.59345376222662,"plays":7841,"deaths":1,"ema":0.3813262294028764,"max":0.9721567000015057,"samples":20,"distAvg":9.022162526845932,"intercept":0.25855065702401155,"min":0,"cancels":1,"sum":5.646177600013289,"avg":0.28230888000066448,"conf":23,"misses":0,"sumDD":2255.607861037677,"slope":0.0026333179995327107},"6961514608":{"plays":36,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18703240654":{"plays":24,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"106471318730303":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"6961501885":{"plays":12,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14040288114":{"last":0.5425802999961888,"sumD":688.9156015515328,"sumI":62.40506820001883,"sumDI":373.0491673992328,"plays":8522,"kfImpact":0.8558333694934845,"deaths":0,"avg":0.5474128789475337,"conf":114,"max":0.7968357999998261,"samples":114,"distAvg":6.04311931185555,"intercept":0.5723457736615295,"min":0,"cancels":0,"sum":62.40506820001883,"misses":0,"ema":0.5709661245940362,"kfTimestamp":10715.7912355,"slope":-0.004125831946604451,"sumDD":5150.177184450022},"12131261750":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14109966583":{"plays":48,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.712076700001,"sum":0,"kfImpact":1.9283333539962769},"13832401783":{"plays":18,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"135088445025559":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.213743100001,"sum":0,"kfImpact":0.8341666460037231},"9576574845":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"85671320882552":{"last":0.3434135999996215,"sumD":57.04515886306763,"sumI":2.887284999975236,"sumDI":27.930346994456487,"plays":1473,"deaths":0,"conf":6,"max":0.5742315000097733,"samples":6,"distAvg":9.507526477177939,"intercept":-0.11274652936644565,"misses":0,"slope":0.06247268387363848,"avg":0.48121416666253938,"sumDD":550.0322467804938,"ema":0.4523254591081145,"min":0,"sum":2.887284999975236,"cancels":0},"10529512138":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.0049229,"sum":0,"kfImpact":0.8125},"133882065946783":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.879645599998,"sum":0,"kfImpact":0.4983333230018616},"9727223016":{"last":0.14132890000473709,"sumD":11.863405704498291,"sumI":0.2224732000104268,"sumDI":1.3093890344998105,"plays":2750,"deaths":0,"conf":2,"max":0.14132890000473709,"samples":2,"distAvg":5.9317028522491459,"min":0,"cancels":0,"sumDD":70.42827458478155,"ema":0.09919968000540393,"misses":0,"avg":0.1112366000052134,"sum":0.2224732000104268},"103669854440627":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11383985345":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.858312199998,"sum":0,"kfImpact":0.6174999922513962},"17413093522":{"last":0.8258246000041254,"sumD":9.405766487121582,"sumI":0.8258246000041254,"sumDI":7.767513346959388,"plays":84,"deaths":0,"conf":1,"max":0.8258246000041254,"samples":1,"distAvg":9.405766487121582,"sumDD":88.46844321025947,"min":0,"kfImpact":1.083333307504654,"cancels":0,"ema":0.8258246000041254,"misses":0,"kfTimestamp":10714.022467299998,"avg":0.8258246000041254,"sum":0.8258246000041254},"13854505129":{"last":0.586767000000691,"sumD":11.081660747528077,"sumI":1.174000500002876,"sumDI":6.504804928274407,"plays":454,"deaths":0,"conf":2,"max":0.5872335000021849,"samples":2,"distAvg":5.540830373764038,"cancels":0,"min":0,"sum":1.174000500002876,"avg":0.587000250001438,"ema":0.5870935500017367,"misses":0,"kfTimestamp":10716.859508000001,"kfImpact":0.9425000309944153,"sumDD":61.56343833578762},"9602131207":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.7980876,"sum":0,"kfImpact":0.5849999845027923},"120278948965320":{"last":0.07726409999304451,"sumD":42.46673393249512,"sumI":5.073973600003683,"sumDI":5.27090319284837,"plays":8847,"deaths":1,"conf":9,"max":2.173530599999822,"samples":6,"distAvg":7.0777889887491869,"intercept":1.5358846912631535,"min":0,"slope":-0.09751949735899823,"cancels":0,"sum":5.073973600003683,"avg":0.8456622666672805,"misses":0,"ema":0.6388247368397775,"sumDD":614.7806845364594},"76587771013330":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.7651597,"sum":0,"kfImpact":1.863333261013031},"134801845956597":{"last":0.6050447000015993,"sumD":8.045088768005371,"sumI":1.216169200022705,"sumDI":4.887657702680436,"plays":75,"deaths":0,"conf":2,"max":0.6111245000211056,"samples":2,"distAvg":4.0225443840026859,"sumDD":33.42686821155121,"min":0,"kfImpact":0.8233333230018616,"avg":0.6080846000113525,"ema":0.6093005600152537,"misses":0,"kfTimestamp":10718.269886299997,"sum":1.216169200022705,"cancels":0},"79441716695622":{"last":1.2481713999877684,"sumD":775.846048116684,"sumI":59.60838399995646,"sumDI":433.24237162999079,"samples":111,"kfImpact":0.65,"deaths":0,"distAvg":6.9896040370872429,"conf":111,"max":1.2481713999877684,"sumDD":6278.528720772754,"slope":0.019403894478148187,"intercept":0.40138692928839678,"min":0,"cancels":0,"avg":0.5370124684680762,"ema":0.9787581226769886,"misses":0,"kfTimestamp":10718.076191499997,"sum":59.60838399995646,"plays":1348},"11346343707":{"plays":13,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"106688736282435":{"last":0.5869108000042616,"lastLearned":9683.8997622,"cancelRate":0.041666666666666667,"sumD":892.0555815696716,"sumI":59.59695739998347,"successes":30,"sumDI":394.24070587057175,"distAvg":5.3416501890399499,"plays":24134,"deaths":1,"misses":4,"ema":0.5430064531084393,"max":2.234192299991264,"samples":167,"slope":0.018710297720881724,"intercept":0.2569241430253929,"min":0.0501356000022497,"cancels":6,"avg":0.37320276886217487,"sumDD":8821.350280309027,"sum":62.3248623999832,"kfTimestamp":10715.315704100001,"conf":170,"kfImpact":2.6},"10569718648":{"plays":796,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"16301719215":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"94911220984648":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.5791599,"sum":0,"kfImpact":0.7800000309944153},"133192383501576":{"plays":51,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14150489371":{"plays":7,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.7544548,"sum":0,"kfImpact":1.841666615009308},"107439297045997":{"last":0.14248769999539946,"sumD":18.55982542037964,"sumI":0.8625415999922552,"sumDI":5.2832384636757789,"plays":663,"deaths":0,"conf":2,"max":0.7200538999968558,"samples":2,"distAvg":9.27991271018982,"cancels":0,"min":0,"avg":0.4312707999961276,"sum":0.8625415999922552,"ema":0.5467840399964189,"misses":0,"kfTimestamp":10716.622848300001,"kfImpact":0.8666666924953461,"sumDD":216.62575451543877},"14411040819":{"plays":4371,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17154401086":{"last":0.48958940000011355,"sumD":32.720046043395999,"sumI":1.9964637999946718,"sumDI":16.383542154702526,"sumDD":303.0413123321441,"plays":61,"deaths":0,"slope":0.0014818838240978074,"conf":4,"max":0.5087474999963888,"samples":4,"distAvg":8.180011510848999,"intercept":0.48699412325980698,"min":0,"avg":0.49911594999866795,"sum":1.9964637999946718,"ema":0.49764792249962189,"misses":0,"kfTimestamp":10715.404706399997,"cancels":0,"kfImpact":0.541666653752327},"97597705019778":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.650640499996,"sum":0,"kfImpact":3.3583332300186159},"83478022548253":{"plays":40,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17429347710":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.2451364,"sum":0,"kfImpact":0.8639583230018616},"17891450790":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.273203199999,"sum":0,"kfImpact":0.541666653752327},"14411249478":{"plays":3922,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.723022099999,"sum":0,"kfImpact":0.5525000154972076},"15560352579":{"plays":27,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.953402599996,"sum":0,"kfImpact":0.8233333230018616},"86167148086945":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"136682938886188":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.929694500002,"sum":0,"kfImpact":0.595833346247673},"18481278868":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18429789282":{"last":0.23753889999352396,"lastLearned":5224.601049199999,"combo":{"119744649456014":{"samples":1,"sum":0.5677644000006694,"avg":0.5677644000006694},"81281779521042":{"samples":6,"sum":3.975602300000901,"avg":0.6626003833334835},"128875759494501":{"samples":1,"sum":0.08611190000010538,"avg":0.08611190000010538},"101464977033970":{"samples":2,"sum":0.3010431000002427,"avg":0.15052155000012136},"80044202039051":{"samples":2,"sum":0.40688000000045579,"avg":0.20344000000022789},"91233168287060":{"samples":4,"sum":0.5131877999992867,"avg":0.12829694999982167},"135906726244054":{"samples":1,"sum":0.1764302999999927,"avg":0.1764302999999927},"18998838518":{"samples":72,"sum":13.694905400001517,"avg":0.1902070194444655},"85652792138826":{"samples":2,"sum":1.464843000001565,"avg":0.7324215000007825},"11130826551":{"samples":1,"sum":0.1667701999995188,"avg":0.1667701999995188},"109175080835575":{"samples":6,"sum":1.8881461000000855,"avg":0.3146910166666809},"123458031797396":{"samples":3,"sum":0.7537272999998095,"avg":0.25124243333326987},"17096542398":{"samples":2,"sum":0.15495910000026925,"avg":0.07747955000013462},"6940137765":{"samples":1,"sum":0.10229400000025635,"avg":0.10229400000025635},"76754008387126":{"samples":1,"sum":0.20785129999967467,"avg":0.20785129999967467},"127153082609965":{"samples":2,"sum":0.260118500000317,"avg":0.1300592500001585},"74564651506542":{"samples":10,"sum":1.3363194999965345,"avg":0.13363194999965345},"72352073483435":{"samples":5,"sum":0.4819813999965845,"avg":0.09639627999931691},"14597046093":{"samples":4,"sum":1.1708034999992379,"avg":0.29270087499980948}},"cancelRate":0.327455919395466,"sumD":1081.8121572732926,"sumI":95.9174299000938,"calEma":0.19578665507851057,"successes":226,"distAvg":4.129054035394247,"sumDI":524.8991471224708,"calSum":5.1919843000032419,"plays":14154,"deaths":13,"slope":0.04803939691642258,"conf":301,"max":2.2755885000005948,"samples":262,"calAvg":0.4719985727275674,"intercept":0.16773979499172032,"min":0.05049909999979718,"avg":0.4991154190843728,"sum":130.76823980010568,"sumDD":7149.053062414531,"cancels":260,"misses":53,"ema":0.3894817255197638,"calSamples":11},"17150208141":{"last":0.8511412999941967,"sumD":300.21680426597598,"sumI":24.57427519997691,"sumDI":246.55253748529086,"plays":578,"deaths":0,"conf":30,"max":1.030940800003009,"samples":30,"distAvg":10.007226808865865,"intercept":0.8147479071874099,"min":0,"slope":0.0004391425878939613,"sum":24.57427519997691,"sumDD":4443.942721323899,"ema":0.8581758537420101,"cancels":0,"misses":0,"avg":0.8191425066658969},"93090194768829":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.106417199997,"sum":0,"kfImpact":0.9750000000000001},"17826113901":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.1763652,"sum":0,"kfImpact":1.841666615009308},"17150065294":{"last":0.6903455999854486,"sumD":310.18745255470278,"sumI":16.38140949992885,"sumDI":207.12760876244205,"plays":18409,"deaths":0,"conf":32,"max":1.3900308999982372,"samples":32,"distAvg":9.693357892334462,"intercept":0.2382241150030488,"min":0,"sumDD":4718.68357511615,"sum":16.38140949992885,"ema":0.4349705551367618,"cancels":0,"misses":0,"avg":0.5119190468727766,"slope":0.02823530657896853},"13840481766":{"plays":360,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14328032590":{"last":0.9525501999960397,"sumD":6.405268669128418,"sumI":0.9525501999960397,"sumDI":6.101339951806642,"plays":283,"deaths":0,"conf":1,"max":0.9525501999960397,"samples":1,"distAvg":6.405268669128418,"min":0,"cancels":0,"sum":0.9525501999960397,"avg":0.9525501999960397,"misses":0,"ema":0.9525501999960397,"sumDD":41.027466723718138},"131174800505496":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.6100946,"sum":0,"kfImpact":0.7258333384990693},"82486344149902":{"plays":59,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18387082851":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.4722626,"sum":0,"kfImpact":0.9750000000000001},"17086022325":{"last":0.638528999988921,"sumD":57.409589767456058,"sumI":3.6960071999928916,"sumDI":35.485903226823399,"sumDD":559.4548284919911,"plays":215,"deaths":0,"slope":0.01197940702882385,"conf":6,"max":0.65870209998684,"samples":6,"distAvg":9.568264961242676,"intercept":0.5013790594684557,"min":0,"kfImpact":0.7150000154972077,"avg":0.6160011999988152,"ema":0.6202800589587117,"misses":0,"kfTimestamp":10717.060903999998,"sum":3.6960071999928916,"cancels":0},"81281779521042":{"last":0.5332842000061646,"lastLearned":10194.7645674,"combo":{"18998838518":{"samples":7,"sum":0.7139925999981642,"avg":0.1019989428568806},"18429789282":{"samples":2,"sum":0.13194280000061554,"avg":0.06597140000030777}},"cancelRate":0.03225806451612903,"sumD":73.9413161277771,"sumI":6.587300600000617,"calEma":0.3862289500002589,"successes":18,"ema":0.5490041025197083,"sumDD":512.7773770803312,"distAvg":1.8959311827635155,"sumDI":40.6583842731693,"calSum":1.0877527000011469,"plays":1959,"deaths":0,"avg":0.5387720307687511,"conf":39,"max":0.5708546999958344,"samples":39,"slope":0.07560411191385896,"intercept":0.025564950267131609,"min":0.49759849999827568,"cancels":2,"sum":21.012109199981297,"misses":43,"calAvg":0.36258423333371567,"kfTimestamp":10715.887536000002,"kfImpact":0.9750000000000001,"calSamples":3},"10104138335":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.106526399999,"sum":0,"kfImpact":2.4266666769981386},"111458184388856":{"last":0.5013593000039691,"lastLearned":8838.990416999999,"cancelRate":0.047619047619047619,"sumD":65.4988784790039,"sumI":5.081290699991769,"successes":4,"sumDI":33.561529455303077,"slope":0.06978499490282494,"plays":677,"deaths":0,"misses":9,"conf":14,"max":0.5935753999947337,"samples":14,"distAvg":4.678491319928851,"intercept":0.03646084279955218,"min":0.4591035999910673,"cancels":1,"sum":7.074389499987774,"ema":0.5162108321162499,"avg":0.5053135357134124,"kfTimestamp":10715.999059399997,"sumDD":446.7061319835566,"kfImpact":0.8666666924953461},"16506076761":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.986425900002,"sum":0,"kfImpact":0.9966666460037232},"14824878981":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.595529899998,"sum":0,"kfImpact":0.4983333230018616},"14326709511":{"last":0.5938943000073778,"sumD":829.0893114209175,"sumI":55.89305799996964,"sumDI":426.3552607874417,"plays":6286,"deaths":1,"conf":110,"max":1.3001658000002863,"samples":107,"distAvg":7.748498237578668,"intercept":0.5739808034766879,"min":0,"slope":-0.006661390873041988,"cancels":0,"sumDD":7434.796918508086,"ema":0.5647690486160042,"misses":0,"avg":0.5223650280370995,"sum":55.89305799996964},"17097895421":{"last":0.05804129999887664,"sumD":17.925209045410158,"sumI":0.05804129999887664,"sumDI":1.040402435747228,"plays":1175,"deaths":0,"conf":1,"max":0.05804129999887664,"samples":1,"distAvg":17.925209045410158,"min":0,"cancels":0,"sumDD":321.3131193216541,"ema":0.05804129999887664,"misses":0,"avg":0.05804129999887664,"sum":0.05804129999887664},"11123981295":{"last":0.7821152999968035,"sumD":34.19342350959778,"sumI":3.8968321999964248,"successes":4,"sumDI":26.634763866161785,"samples":5,"kfImpact":1.354166615009308,"deaths":0,"slope":-0.00046542871191321657,"conf":5,"max":0.7821152999968035,"sumDD":264.8694022346504,"distAvg":6.838684701919556,"intercept":0.78254936021128,"misses":1,"sum":3.8968321999964248,"avg":0.7793664399992849,"min":0.7776004999977886,"cancels":0,"kfTimestamp":10716.746024200002,"ema":0.6532816429143606,"plays":168},"17154406492":{"last":0.09044810000341386,"sumD":97.27708625793457,"sumI":1.7164632999993046,"sumDI":15.678994470813209,"sumDD":2531.4616409957418,"plays":400,"deaths":0,"slope":-0.02772835259712272,"conf":5,"max":1.383459299999231,"samples":5,"distAvg":19.455417251586917,"intercept":0.8827593294760071,"min":0,"avg":0.3432926599998609,"sum":1.7164632999993046,"ema":0.39614084463027607,"misses":0,"kfTimestamp":10715.433833900002,"cancels":0,"kfImpact":0.7908333539962769},"80503383167824":{"last":0.5238012000045274,"sumD":44.24470233917236,"sumI":1.5719525000022259,"sumDI":23.393440086948119,"sumDD":746.4717359746073,"plays":68,"deaths":0,"slope":0.002234569597728746,"conf":3,"max":0.5809271000034642,"samples":3,"distAvg":14.748234113057455,"intercept":0.49102821109818448,"min":0,"kfImpact":0.6283333152532578,"avg":0.5239841666674087,"ema":0.5080749089992604,"misses":0,"kfTimestamp":10718.308558199999,"sum":1.5719525000022259,"cancels":0},"88824029979745":{"last":0.2301244999980554,"sumD":90.66211295127869,"sumI":3.514010099970619,"sumDI":37.408457062914028,"plays":2450,"deaths":1,"conf":12,"max":0.4954736999934539,"samples":9,"distAvg":10.073568105697632,"intercept":0.3006333585631586,"misses":0,"slope":0.008915630207477878,"avg":0.39044556666340216,"sumDD":1138.7194528798946,"ema":0.3579898115179769,"min":0,"sum":3.514010099970619,"cancels":0},"123397663657768":{"plays":97,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.770433400001,"sum":0,"kfImpact":3.0658333539962769},"18998838518":{"last":0.8989944999921136,"combo":{"13959320065":{"samples":2,"sum":0.30035549999956859,"avg":0.15017774999978429},"9465728971":{"samples":13,"sum":0.8240347999981168,"avg":0.06338729230754745},"119744649456014":{"samples":1,"sum":0.13908190000074684,"avg":0.13908190000074684},"136583255994029":{"samples":7,"sum":0.43645849999847999,"avg":0.062351214285497138},"13959318029":{"samples":3,"sum":0.5204040999997233,"avg":0.1734680333332411},"101464977033970":{"samples":1,"sum":0.15690119999999298,"avg":0.15690119999999298},"72352073483435":{"samples":1,"sum":1.2277954000001046,"avg":1.2277954000001046},"108088498534310":{"samples":1,"sum":0.1479962000012165,"avg":0.1479962000012165},"123458031797396":{"samples":6,"sum":1.0084467000015139,"avg":0.1680744500002523},"11273001982":{"samples":2,"sum":0.40504780000082976,"avg":0.20252390000041488},"11361464104":{"samples":1,"sum":0.20234900000104973,"avg":0.20234900000104973},"91276593220093":{"samples":4,"sum":0.22355130000141799,"avg":0.055887825000354499},"11497901053":{"samples":1,"sum":0.1523817000015697,"avg":0.1523817000015697},"130216339682903":{"samples":4,"sum":0.7041029999963939,"avg":0.17602574999909849},"127153082609965":{"samples":2,"sum":0.19218249999903493,"avg":0.09609124999951746},"18429789282":{"samples":4,"sum":0.36143799999990736,"avg":0.09035949999997684},"16417788544":{"samples":2,"sum":0.4023144999991928,"avg":0.2011572499995964},"113631162072406":{"samples":8,"sum":2.019314500001201,"avg":0.2524143125001501},"115338865375824":{"samples":1,"sum":0.10179340000104276,"avg":0.10179340000104276},"13966232587":{"samples":1,"sum":0.2018260000004375,"avg":0.2018260000004375},"73529457986066":{"samples":12,"sum":0.6910960999975941,"avg":0.05759134166646618},"91233168287060":{"samples":2,"sum":0.2534229000011692,"avg":0.1267114500005846},"101162579246421":{"samples":2,"sum":0.39242689999991856,"avg":0.19621344999995928},"128875759494501":{"samples":3,"sum":0.49192159999802245,"avg":0.16397386666600748},"119333842262474":{"samples":1,"sum":0.20391580000068644,"avg":0.20391580000068644},"74564651506542":{"samples":1,"sum":0.1553593999997247,"avg":0.1553593999997247},"17096542398":{"samples":3,"sum":0.5649818000001687,"avg":0.18832726666672293},"16417792446":{"samples":2,"sum":0.27855240000099,"avg":0.139276200000495},"9844571694":{"samples":2,"sum":0.8090244000013627,"avg":0.40451220000068136},"134944919039812":{"samples":40,"sum":5.096443599995837,"avg":0.12741108999989593},"14597046093":{"samples":7,"sum":1.2276598999978888,"avg":0.1753799857139841}},"cancelRate":0.03260869565217391,"sumD":2264.271808385849,"sumI":52.780018699894757,"sumDI":621.7961677854686,"plays":145623,"deaths":2,"conf":216,"max":1.480729799997789,"samples":210,"distAvg":10.782246706599281,"intercept":0.18825505389743506,"misses":11,"sum":52.780018699894757,"cancels":3,"avg":0.2513334223804512,"min":0.05010420000326121,"ema":0.4677586991737466,"sumDD":33423.702298586315,"slope":0.00585020638086578},"13838989601":{"last":0.808343299999251,"sumD":19.748422622680665,"sumI":0.808343299999251,"sumDI":15.963505112597553,"plays":220,"deaths":0,"conf":1,"max":0.808343299999251,"samples":1,"distAvg":19.748422622680665,"min":0,"sum":0.808343299999251,"avg":0.808343299999251,"misses":0,"cancels":0,"ema":0.8083432999992509,"sumDD":390.00019608400546},"11498096947":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10716.2940179,"kfImpact":3.910833477973938,"deaths":0},"14485005225":{"plays":104,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"71449404731240":{"plays":341,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17732915133":{"plays":37,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.331170700003,"sum":0,"kfImpact":1.191666692495346},"9461059177":{"plays":4256,"last":0,"ema":0.025,"max":0,"samples":0,"min":{"m":null,"t":"numeric","v":"inf"},"conf":0,"sum":0,"misses":1,"cancels":0,"deaths":0,"avg":0,"combo":{"18998838518":{"samples":1,"sum":0.1211477000015293,"avg":0.1211477000015293},"119333842262474":{"samples":1,"sum":0.0753071999988606,"avg":0.0753071999988606}}},"13959320065":{"last":0.2846510999952443,"combo":{"18998838518":{"samples":3,"sum":0.28867819999868518,"avg":0.09622606666622839},"16417788544":{"samples":1,"sum":0.09972120000020368,"avg":0.09972120000020368},"134944919039812":{"samples":3,"sum":0.272378600000593,"avg":0.09079286666686433},"13959318029":{"samples":1,"sum":0.06227290000060748,"avg":0.06227290000060748}},"sumD":1.3328490257263184,"sumI":0.2846510999952443,"sumDI":0.3793969413005862,"plays":82,"deaths":0,"ema":0.2846510999952443,"max":0.2846510999952443,"samples":1,"distAvg":1.3328490257263184,"sumDD":1.776486525379596,"min":0,"kfImpact":0.6467500030994415,"sum":0.2846510999952443,"conf":1,"misses":0,"kfTimestamp":10716.087696499999,"avg":0.2846510999952443,"cancels":0},"17827779174":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10716.1414219,"kfImpact":1.841666615009308,"deaths":0},"86195378216296":{"plays":216,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.412926199999,"sum":0,"kfImpact":0.39000001549720766},"9601964654":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.829469600001,"sum":0,"kfImpact":0.5849999845027923},"11273001982":{"last":0.13819890000013403,"combo":{"18998838518":{"samples":7,"sum":1.8800410999974702,"avg":0.2685772999996386},"13966232587":{"samples":4,"sum":0.7643760999999358,"avg":0.19109402499998397},"134944919039812":{"samples":1,"sum":0.17106450000028418,"avg":0.17106450000028418},"113631162072406":{"samples":4,"sum":0.7896959999998217,"avg":0.1974239999999554}},"sumD":108.21935069561005,"successes":5,"calEma":0.2299910000001546,"slope":-0.0004746304704618432,"samples":43,"sumDI":14.560034067983171,"calSum":0.2299910000001546,"plays":15935,"deaths":0,"calAvg":0.2299910000001546,"conf":43,"max":0.25414530000125526,"sumDD":1936.6630279205577,"distAvg":2.51672908594442,"intercept":0.1430357256124166,"min":0.05128080000213231,"sumI":6.099172000000181,"cancels":0,"ema":0.1300758117641447,"sum":6.446914600001037,"avg":0.149928246511652,"misses":1,"calSamples":1},"9602711729":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.835795400002,"sum":0,"kfImpact":0.48750000000000007},"10546151222":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10716.778529900002,"kfImpact":0.4549999922513962,"deaths":0},"108322405941111":{"plays":195,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.1678713,"sum":0,"kfImpact":0.8125},"18958397073":{"last":0.10491959999490064,"sumD":1168.3177040815354,"sumI":28.75074929995617,"sumDI":291.7449274522134,"plays":77634,"deaths":1,"conf":122,"max":2.254820000001928,"samples":119,"distAvg":9.817795832617945,"intercept":0.2268993680070913,"misses":0,"cancels":0,"avg":0.2443071697475181,"sum":29.072553199954656,"min":0,"ema":0.20316853672427277,"sumDD":17797.534683554826,"slope":0.001497644434385968},"6953675030":{"plays":654,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.183317099996,"sum":0,"kfImpact":0.4116666615009308},"9466742285":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"84008666719547":{"last":0.306060000002617,"sumD":137.2400369644165,"sumI":2.9722224000215649,"sumDI":28.937456575417298,"plays":11628,"deaths":0,"conf":13,"max":0.6437365000019781,"samples":13,"distAvg":10.556925920339732,"intercept":0.29128858006827365,"min":0,"sum":2.9722224000215649,"avg":0.22863249230935113,"misses":0,"cancels":0,"ema":0.23090219223886306,"sumDD":1859.9612265364186,"slope":-0.005935069378312563},"9780037814":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.800545500002,"sum":0,"kfImpact":0.9750000000000001},"10348188826":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.616269999999,"sum":0,"kfImpact":1.3},"17819993121":{"plays":65,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.262535499998,"sum":0,"kfImpact":0.6391666769981385},"9465728971":{"last":0.05314610000641551,"lastLearned":5230.718571400001,"combo":{"18429789282":{"samples":77,"sum":14.626886800006105,"avg":0.18995956883124813},"119744649456014":{"samples":4,"sum":0.6537410999972053,"avg":0.16343527499930134},"18998838518":{"samples":44,"sum":8.033661200002826,"avg":0.1825832090909733},"128875759494501":{"samples":2,"sum":0.4148860999994213,"avg":0.20744304999971065},"74564651506542":{"samples":8,"sum":1.4088948000007804,"avg":0.17611185000009756},"72352073483435":{"samples":3,"sum":0.6067102000015439,"avg":0.20223673333384796},"14597046093":{"samples":5,"sum":2.1456230000021607,"avg":0.4291246000004321},"123458031797396":{"samples":1,"sum":0.12897720000000846,"avg":0.12897720000000846},"6940137765":{"samples":1,"sum":0.20509409999976925,"avg":0.20509409999976925},"76754008387126":{"samples":1,"sum":0.2002477000005456,"avg":0.2002477000005456},"127153082609965":{"samples":1,"sum":0.05696870000065246,"avg":0.05696870000065246},"80044202039051":{"samples":1,"sum":0.10377519999929064,"avg":0.10377519999929064},"17096542398":{"samples":1,"sum":0.20005680000031135,"avg":0.20005680000031135},"74973280679545":{"samples":1,"sum":0.32343199999922947,"avg":0.32343199999922947}},"cancelRate":0.16,"sumD":1133.8213156461716,"sumI":48.593014899985067,"calEma":0.1971037874997137,"successes":217,"distAvg":5.224983021410929,"sumDI":361.09838800767366,"calSum":1.7325539999983449,"plays":18637,"deaths":0,"slope":0.017963738463571845,"conf":217,"max":1.3280290999973659,"samples":217,"calAvg":0.28875899999972418,"intercept":0.13007071576633318,"min":0.053002599999672387,"avg":0.35092143686608309,"sum":76.14995179994003,"sumDD":11891.814076654888,"cancels":124,"misses":72,"ema":0.26152443849939746,"calSamples":6},"130863537121533":{"last":0.5218308000003162,"sumD":4.337817668914795,"sumI":0.5218308000003162,"sumDI":2.2636068644253144,"plays":412,"deaths":0,"conf":1,"max":0.5218308000003162,"samples":1,"distAvg":4.337817668914795,"sumDD":18.816662128749387,"min":0,"kfImpact":1.0400000154972078,"avg":0.5218308000003162,"ema":0.5218308000003162,"misses":0,"kfTimestamp":10716.2455567,"cancels":0,"sum":0.5218308000003162},"93527501035228":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.1247945,"sum":0,"kfImpact":1.7333333849906923},"131177999571320":{"plays":45,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13914942710":{"plays":10,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.7929868,"sum":0,"kfImpact":2.524166738986969},"14628609085":{"last":1.078963499996462,"sumD":2260.465719103813,"sumI":227.76922859994375,"sumDI":1911.873745087641,"plays":26245,"deaths":1,"conf":306,"max":2.517581000000064,"samples":303,"distAvg":7.460282901332716,"intercept":0.5606515956369008,"min":0,"slope":0.025610560970999658,"sum":227.76922859994375,"sumDD":25166.96270415257,"ema":0.665944686040053,"misses":0,"avg":0.7517136257423887,"cancels":0},"6748586773":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13967197291":{"plays":637,"last":0,"combo":{"18998838518":{"samples":2,"sum":0.4113608999996359,"avg":0.20568044999981795}},"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"100918285736290":{"plays":110,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.212378099997,"sum":0,"kfImpact":1.083333307504654},"71922325917635":{"plays":171,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5421766,"sum":0,"kfImpact":0.920833307504654},"18193786054":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.4067011,"sum":0,"kfImpact":2.870833230018616},"95156323937837":{"last":0.5340360999980476,"sumD":69.3434534072876,"sumI":8.463907500001369,"sumDI":76.46236004609689,"plays":186,"deaths":0,"conf":7,"max":2.5102396000002047,"samples":7,"distAvg":9.906207629612514,"intercept":1.368321042541599,"misses":0,"slope":-0.01606986302289806,"avg":1.2091296428573384,"sumDD":1146.3536675669489,"ema":1.0317752103503509,"min":0,"sum":8.463907500001369,"cancels":0},"93674214784193":{"last":0.23846770000091056,"sumD":5.211380958557129,"sumI":0.23846770000091056,"sumDI":1.242746031015659,"plays":218,"deaths":0,"conf":1,"max":0.23846770000091056,"samples":1,"distAvg":5.211380958557129,"sum":0.23846770000091056,"min":0,"cancels":0,"avg":0.23846770000091056,"ema":0.23846770000091056,"misses":0,"kfTimestamp":10719.437739,"kfImpact":0.39000001549720766,"sumDD":27.15849149521182},"101485195772910":{"last":0.3966050000017276,"sumD":555.9518156051636,"sumI":46.36253990004707,"sumDI":313.532160709346,"plays":1606,"deaths":0,"conf":75,"max":2.907336399999622,"samples":75,"distAvg":7.412690874735515,"intercept":0.9848961097659369,"min":0,"slope":-0.04947311540382123,"sum":46.36253990004707,"sumDD":4730.298825681261,"ema":0.38194753539965578,"misses":0,"avg":0.6181671986672942,"cancels":0},"72516337412467":{"last":0.14219920000323328,"sumD":467.86275148391726,"sumI":12.113996200041584,"sumDI":257.903886868011,"plays":20431,"deaths":0,"conf":23,"max":1.104205000003276,"samples":23,"distAvg":20.341858760170316,"intercept":0.21373886025896758,"min":0,"slope":0.015384858895595925,"sum":12.113996200041584,"sumDD":10263.56086069892,"ema":0.4241343356592247,"misses":0,"avg":0.5266954869583297,"cancels":0},"108141441255434":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.118832400003,"sum":0,"kfImpact":0.8125},"91064180025830":{"last":0.6406165000080364,"sumD":321.42506766319277,"sumI":22.567521100027535,"sumDI":159.65109308717127,"plays":18574,"deaths":2,"conf":51,"max":1.2375413999998273,"samples":45,"distAvg":7.142779281404283,"intercept":0.527473825000971,"min":0,"avg":0.5015004688895007,"sum":22.567521100027535,"misses":0,"cancels":0,"ema":0.5753003235927711,"sumDD":2720.400125955087,"slope":-0.0036363094935734608},"16874792738":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.004247099998,"sum":0,"kfImpact":1.0291666924953463},"96040009026472":{"last":0.25322289999894567,"sumD":436.8759813308716,"sumI":47.30403169994315,"sumDI":290.1032188016709,"samples":69,"kfImpact":0.65,"deaths":1,"distAvg":6.3315359613169799,"conf":72,"max":2.611319799998455,"sumDD":3012.3298357979649,"slope":-0.03819117089715467,"intercept":0.9273744487509076,"min":0,"cancels":0,"avg":0.6855656768107703,"ema":0.5097288354159496,"misses":0,"kfTimestamp":10718.069657,"sum":47.30403169994315,"plays":705},"16362368108":{"plays":12,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17165716229":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.9302054,"sum":0,"kfImpact":0.8449999690055847},"18971458640":{"last":0.10608899999351707,"sumD":109.02474927902222,"sumI":4.243075099995622,"sumDI":40.02414756466804,"plays":4700,"deaths":0,"conf":13,"max":0.6965220000020054,"samples":13,"distAvg":8.3865191753094,"intercept":0.23905791057989005,"min":0,"avg":0.3263903923073555,"sum":4.243075099995622,"misses":0,"cancels":0,"ema":0.31296338460132008,"sumDD":1340.6639878956835,"slope":0.010413436123127153},"108597439219369":{"last":0.16786890001094435,"combo":{"130216339682903":{"samples":1,"sum":0.05626769999980752,"avg":0.05626769999980752}},"sumD":40.147148847579959,"sumI":1.0267377000054694,"sumDI":6.706939978081713,"plays":6031,"deaths":0,"ema":0.17589201958254925,"max":0.4443808999931207,"samples":5,"distAvg":8.02942976951599,"intercept":0.45420681247816238,"min":0,"slope":-0.03099339300804041,"cancels":0,"avg":0.20534754000109388,"conf":5,"misses":0,"sum":1.0267377000054694,"sumDD":371.9556786529707},"17188155225":{"last":0.9343848999997135,"sumD":823.7722573280335,"sumI":43.47981809992325,"sumDI":375.25785157092477,"plays":1005,"deaths":0,"conf":87,"max":2.9080518999980997,"samples":87,"distAvg":9.468646635954407,"intercept":0.708772541469819,"min":0,"slope":-0.022073325298584576,"sum":43.47981809992325,"sumDD":9450.742107315025,"ema":1.1119985196269518,"misses":0,"avg":0.49976802413704887,"cancels":0},"134281749755415":{"last":0.5598070999840275,"sumD":21.361785888671876,"sumI":1.1106036999844947,"sumDI":11.857235299367444,"plays":64,"deaths":0,"conf":2,"max":0.5598070999840275,"samples":2,"distAvg":10.680892944335938,"sumDD":228.77976126689465,"min":0,"kfImpact":0.6174999922513962,"avg":0.5553018499922473,"ema":0.5534997499955352,"misses":0,"kfTimestamp":10718.314290499999,"sum":1.1106036999844947,"cancels":0},"18550826407":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.519805199998,"sum":0,"kfImpact":2.0583333849906926},"130867999752530":{"plays":58,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.456093300003,"sum":0,"kfImpact":0.65},"11637460570":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.983549899996,"sum":0,"kfImpact":2.1125000000000004},"11151874734":{"plays":401,"last":0,"combo":{"18998838518":{"samples":5,"sum":0.9553534000024229,"avg":0.19107068000048459},"130216339682903":{"samples":2,"sum":0.3514451999999437,"avg":0.17572259999997187},"11361552631":{"samples":1,"sum":0.1867376999998669,"avg":0.1867376999998669},"11361464104":{"samples":1,"sum":0.059389500000179399,"avg":0.059389500000179399}},"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"89563775107125":{"plays":10,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"119333842262474":{"last":0.14124539999465925,"combo":{"113631162072406":{"samples":4,"sum":0.6962742000014259,"avg":0.17406855000035649},"18998838518":{"samples":3,"sum":0.48132989999976419,"avg":0.16044329999992139},"101464977033970":{"samples":1,"sum":0.12924840000050609,"avg":0.12924840000050609},"115880291306156":{"samples":1,"sum":0.15195660000063072,"avg":0.15195660000063072}},"cancelRate":0.02702702702702703,"sumD":72.63877665996552,"sumI":5.605165299991995,"sumDI":33.5065939378548,"distAvg":6.05323138833046,"plays":500,"deaths":0,"cancels":1,"ema":0.42343230457095967,"max":0.5640385999995488,"samples":12,"slope":-0.0020653607105364758,"intercept":0.47959921461391016,"min":0,"sum":6.169203899991544,"avg":0.5141003249992954,"sumDD":644.3941205961003,"misses":1,"kfTimestamp":10715.494425700002,"conf":12,"kfImpact":1.4625000000000002},"93437441193278":{"last":1.5874742000014522,"sumD":4990.426562547684,"sumI":422.8857506000122,"sumDI":5361.15312710883,"sumDD":89774.27853628468,"plays":1896,"deaths":3,"slope":-0.005402619637983775,"conf":393,"max":1.6671618000000308,"samples":384,"distAvg":12.995902506634593,"intercept":1.1714768936165319,"min":0,"avg":1.1012649755208653,"sum":422.8857506000122,"ema":1.441681275627848,"misses":0,"kfTimestamp":10717.630162200003,"cancels":0,"kfImpact":1.083333307504654},"91657425744872":{"plays":97,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.2038932,"sum":0,"kfImpact":1.3108333230018617},"103172511870517":{"last":1.1108316000027117,"sumD":571.0582246780396,"sumI":33.1095908999996,"sumDI":371.3843894506907,"plays":2122,"deaths":0,"conf":51,"max":1.27611109999998,"samples":51,"distAvg":11.197220091726266,"intercept":0.6236259469084403,"misses":0,"slope":0.002284649010010698,"avg":0.6492076647058745,"sumDD":6678.34020855747,"ema":0.8294698381561196,"min":0,"sum":33.1095908999996,"cancels":0},"9709989821":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"103588035476947":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10615996356":{"plays":8,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"91827279173630":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.384566599998,"sum":0,"kfImpact":2.6},"9680284098":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10714.254949399998,"kfImpact":3.25,"deaths":0},"10556820962":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.7527519,"sum":0,"kfImpact":0.7474999845027924},"95325959713717":{"last":0.12198789999820292,"sumD":0,"sumI":0.2421169999979611,"sumDI":0,"plays":3460,"deaths":1,"conf":5,"max":0.12198789999820292,"samples":2,"distAvg":0,"min":0,"sum":0.2421169999979611,"sumDD":0,"ema":0.12068673999929158,"cancels":0,"misses":0,"avg":0.12105849999898055},"110400553220434":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.206146700002,"sum":0,"kfImpact":0.7908333539962769},"84011433093848":{"last":1.0526823000109289,"sumD":22.679140090942384,"sumI":1.0526823000109289,"sumDI":23.873929353203296,"plays":12883,"deaths":0,"conf":1,"max":1.0526823000109289,"samples":1,"distAvg":22.679140090942384,"min":0,"cancels":0,"sumDD":514.3433952645901,"ema":1.0526823000109289,"misses":0,"avg":1.0526823000109289,"sum":1.0526823000109289},"110505793895493":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"15303181958":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.3339232,"sum":0,"kfImpact":0.7474999845027924},"93188540542191":{"plays":245,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.690728000001,"sum":0,"kfImpact":0.44416666924953465},"17096542398":{"last":0.4740955000015674,"combo":{"18429789282":{"samples":1,"sum":0.07308929999999237,"avg":0.07308929999999237},"130216339682903":{"samples":1,"sum":0.1733302000011463,"avg":0.1733302000011463},"18998838518":{"samples":16,"sum":3.3734782000065026,"avg":0.2108423875004064},"81281779521042":{"samples":1,"sum":0.07070349999958126,"avg":0.07070349999958126},"74564651506542":{"samples":1,"sum":0.07961190000060015,"avg":0.07961190000060015},"14597046093":{"samples":2,"sum":0.16806430000178808,"avg":0.08403215000089404}},"sumD":665.0208678245545,"sumI":17.78290689995083,"sumDI":202.57944704227178,"plays":4803,"deaths":0,"ema":0.37660459690267236,"max":0.5809926000001724,"samples":57,"distAvg":11.667032768851833,"intercept":0.32724768488424957,"min":0.05763169999409001,"slope":-0.0013085471156688155,"cancels":0,"sumDD":11499.083351949042,"sum":17.78290689995083,"misses":0,"conf":57,"avg":0.3119808228061549},"6954458549":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10716.3645331,"kfImpact":1.3,"deaths":0},"14040639604":{"plays":4197,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17891436342":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.250079099998,"sum":0,"kfImpact":0.6283333152532578},"16927623210":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.2474391,"sum":0,"kfImpact":1.0291666924953463},"17165722027":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.923598100002,"sum":0,"kfImpact":0.8449999690055847},"121890671665317":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.698154899997,"sum":0,"kfImpact":1.6791666150093079},"13145469832":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"121073694203767":{"plays":234,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"11124438268":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10714.078065100002,"kfImpact":0.4549999922513962,"deaths":0},"14040016097":{"plays":1150,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.814870900002,"sum":0,"kfImpact":3.25},"17138960679":{"plays":32,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18247374260":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.429201799998,"sum":0,"kfImpact":2.166666615009308},"17810680902":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.699199499999,"sum":0,"kfImpact":3.5100000619888309},"137206728324414":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.756868199998,"sum":0,"kfImpact":1.7875},"17388003798":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.219679299997,"sum":0,"kfImpact":1.278333353996277},"9602685694":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.653143399999,"sum":0,"kfImpact":0.325},"9405588286":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.303021599997,"sum":0,"kfImpact":0.19500000774860383},"14411175349":{"last":1.4705166999920039,"sumD":26.394214630126954,"sumI":1.4705166999920039,"sumDI":38.81313339677496,"plays":3881,"deaths":0,"conf":1,"max":1.4705166999920039,"samples":1,"distAvg":26.394214630126954,"cancels":0,"min":0,"sum":1.4705166999920039,"avg":1.4705166999920039,"ema":1.4705166999920039,"misses":0,"kfTimestamp":10713.734732600002,"kfImpact":0.3141666576266289,"sumDD":696.6545659412077},"10348081224":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17166793932":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.916975499997,"sum":0,"kfImpact":0.8449999690055847},"9695020784":{"plays":17,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"139341692932096":{"plays":51,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10546059749":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"16927392556":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.040241100003,"sum":0,"kfImpact":1.6358333230018616},"11642041325":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.9765282,"sum":0,"kfImpact":1.061666661500931},"93604577018528":{"last":0.5456593000017165,"sumD":17.1117844581604,"sumI":2.184680500002287,"sumDI":9.341292614972764,"plays":461,"kfImpact":1.083333307504654,"deaths":0,"avg":0.5461701250005717,"conf":4,"max":0.5554429000003438,"samples":4,"distAvg":4.2779461145401,"intercept":0.5478932210822615,"min":0,"cancels":0,"sum":2.184680500002287,"misses":0,"ema":0.5446833775006816,"kfTimestamp":10716.505107899997,"slope":-0.00040278583122708024,"sumDD":84.75494326629155},"9775869819":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"111873467408104":{"last":0.5312069000210613,"sumD":29.144548892974855,"sumI":2.2069464000378504,"sumDI":15.968470277944015,"sumDD":225.83213778441428,"plays":163,"deaths":0,"slope":-0.008281611731690697,"conf":4,"max":0.5830597000021953,"samples":4,"distAvg":7.286137223243713,"intercept":0.612077559516186,"min":0,"kfImpact":0.6933333694934846,"avg":0.5517366000094626,"ema":0.5479667634102953,"misses":0,"kfTimestamp":10718.276085099998,"sum":2.2069464000378504,"cancels":0},"18775500687":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.5580108,"sum":0,"kfImpact":0.9966666460037232},"99293053680886":{"last":0.31119930000568277,"lastLearned":8848.9097475,"cancelRate":0.3433734939759036,"sumD":302.42909801006319,"sumI":16.876261800016438,"sumDI":130.42801018457494,"plays":5607,"deaths":0,"successes":26,"ema":0.32938259759470575,"max":1.0045881000005466,"samples":71,"distAvg":4.259564760705115,"intercept":0.12326243480884318,"misses":32,"cancels":57,"sum":33.210444400023337,"avg":0.46775273802849767,"min":0.051308499998413029,"conf":71,"sumDD":3467.386554759366,"slope":0.026864574149932584},"11497886799":{"plays":3641,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"129485463061451":{"plays":31,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"135906726244054":{"last":0.5073889000050258,"lastLearned":10207.793782400002,"combo":{"18998838518":{"samples":1,"sum":0.10372300000017276,"avg":0.10372300000017276}},"cancelRate":0.058823529411764708,"sumD":33.1066632270813,"sumI":3.2670324000064285,"calEma":0.37751372499860738,"successes":7,"slope":0.09741412141503327,"ema":0.5575448521342357,"distAvg":1.2733332010415884,"sumDI":18.007652792983703,"calSum":1.1935433999969974,"plays":840,"deaths":0,"sum":14.237248399991586,"conf":26,"max":0.56193870000061,"sumDD":184.30801653173399,"calAvg":0.3978477999989991,"intercept":0.0016144572598812968,"min":0.5073889000050258,"cancels":1,"avg":0.5475864769227533,"misses":20,"samples":26,"kfTimestamp":10715.9032343,"kfImpact":0.9750000000000001,"calSamples":3},"9726975499":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14089180282":{"last":0.6015625,"sumD":115.38657879829407,"sumI":8.958655100014312,"sumDI":59.425304917107407,"plays":6836,"kfImpact":0.8775000154972077,"deaths":0,"sumDD":1083.332707704627,"conf":16,"max":0.6451751999993576,"samples":16,"slope":-0.020626600007667477,"intercept":0.7086679941962455,"min":0,"sum":8.958655100014312,"cancels":0,"misses":0,"ema":0.5881609164602324,"kfTimestamp":10715.747574399997,"avg":0.5599159437508945,"distAvg":7.211661174893379},"11610189089":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.0008198,"sum":0,"kfImpact":0.19500000774860383},"17086024936":{"last":0.6173936999985017,"sumD":67.02985715866089,"sumI":3.587129800027469,"sumDI":51.246146504377367,"sumDD":1079.3050157340716,"plays":226,"deaths":0,"slope":0.017471529431468979,"conf":5,"max":0.8877418000192847,"samples":5,"distAvg":13.405971431732178,"intercept":0.48320313557855279,"min":0,"kfImpact":0.7150000154972077,"avg":0.7174259600054939,"ema":0.71375267551532,"misses":0,"kfTimestamp":10716.8197276,"sum":3.587129800027469,"cancels":0},"14040293266":{"last":0.508157599993865,"sumD":297.25768435001376,"sumI":30.339454999959345,"sumDI":166.11994037668996,"kfImpact":0.8558333694934845,"plays":5293,"deaths":0,"avg":0.5618417592585063,"conf":54,"max":0.8479156999965198,"sumDD":1831.1723592521344,"slope":-0.004577373776911349,"intercept":0.5870391579497868,"min":0,"sum":30.339454999959345,"cancels":0,"misses":0,"ema":0.5331110952344129,"kfTimestamp":10715.779609899997,"distAvg":5.504771932407662,"samples":54},"9602099428":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.806684299998,"sum":0,"kfImpact":0.5849999845027923},"91983784248298":{"plays":286,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.237469499996,"sum":0,"kfImpact":1.0400000154972078},"101807930385326":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17155718668":{"plays":78,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10715.229383099999,"kfImpact":0.65,"deaths":0},"10525931082":{"plays":20,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.927061000002,"sum":0,"kfImpact":1.4733333230018618},"6959239471":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"16669192163":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.992416499997,"sum":0,"kfImpact":0.8883333384990693},"83235432571742":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11497901053":{"last":0.2093064000000595,"cancelRate":0.125,"sumD":11.602504253387452,"sumI":0.41461420000268847,"sumDI":2.4193696298095337,"plays":3681,"deaths":0,"conf":2,"max":0.2093064000000595,"samples":2,"distAvg":5.801252126693726,"min":0.20530780000262895,"avg":0.20730710000134423,"cancels":2,"misses":0,"ema":0.2065073800018581,"sum":0.41461420000268847,"sumDD":92.13581985363749},"97252739510899":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.136942799996,"sum":0,"kfImpact":0.7041666924953461},"126843720892013":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.187659299998,"sum":0,"kfImpact":1.0291666924953463},"84759120076989":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"109175080835575":{"last":0.12900990000343882,"lastLearned":9469.6730301,"combo":{"18429789282":{"samples":1,"sum":0.2006559000001289,"avg":0.2006559000001289},"11130826551":{"samples":1,"sum":0.8011899000011908,"avg":0.8011899000011908},"18998838518":{"samples":2,"sum":0.201371700000891,"avg":0.1006858500004455},"135906726244054":{"samples":2,"sum":1.6888508000010916,"avg":0.8444254000005458}},"cancelRate":0.06060606060606061,"sumD":123.0238208770752,"sumI":9.922773999991478,"calEma":0.7347616000006383,"successes":17,"kfImpact":0.9750000000000001,"ema":0.39571926278877259,"min":0.12900990000343882,"sumDI":66.41627637743849,"calSum":1.8433536000011373,"plays":1279,"deaths":0,"avg":0.5282832730760604,"conf":26,"max":0.6327741999994032,"samples":26,"distAvg":4.731685418349046,"intercept":0.13828404302136097,"misses":12,"sum":13.735365099977571,"cancels":2,"calAvg":0.6144512000003791,"sumDD":960.56596193512,"kfTimestamp":10715.895870300003,"slope":0.05143222537168951,"calSamples":3},"98821957235032":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"10556952063":{"plays":78,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14321472472":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.390199599999,"sum":0,"kfImpact":1.8850000619888306},"9702247630":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.2081062,"sum":0,"kfImpact":1.2891666769981385},"122823331494331":{"last":1.0263935000111815,"sumD":651.2828063964844,"sumI":32.67081920009514,"sumDI":402.10443264136037,"samples":53,"kfImpact":0.8016666769981384,"deaths":0,"distAvg":12.288354837669516,"conf":53,"max":1.1388073999987683,"sumDD":9100.643563711992,"slope":0.0005775332406690137,"intercept":0.6093336175533013,"min":0,"cancels":0,"avg":0.6164305509451913,"ema":0.7548036332958033,"misses":0,"kfTimestamp":10718.1541459,"sum":32.67081920009514,"plays":126},"13966232587":{"plays":920,"last":0,"combo":{"18998838518":{"samples":4,"sum":0.6646842000009201,"avg":0.16617105000023003},"134944919039812":{"samples":1,"sum":0.16089589999864985,"avg":0.16089589999864985}},"max":0,"samples":0,"conf":0,"min":0,"misses":0,"sum":0,"avg":0,"deaths":0,"kfTimestamp":10716.064992,"cancels":0,"kfImpact":0.65},"14812890781":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.602572199998,"sum":0,"kfImpact":0.4983333230018616},"104764556635506":{"last":0.16249930000049063,"sumD":146.47683668136598,"sumI":4.143557700001111,"sumDI":56.51101797199137,"plays":10154,"deaths":0,"conf":12,"max":0.7228355999977794,"samples":12,"distAvg":12.206403056780497,"intercept":-0.022156000364929708,"min":0,"sumDD":1985.0463661326774,"cancels":0,"ema":0.2666415039192136,"misses":0,"avg":0.3452964750000926,"sum":4.143557700001111,"slope":0.03010325594327374},"11498362171":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.2835413,"sum":0,"kfImpact":0.541666653752327},"117782909971937":{"plays":147,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"111814113053890":{"plays":13,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11361697224":{"last":0.5051136000038241,"combo":{"11361791134":{"samples":3,"sum":2.274903699999413,"avg":0.7583012333331377},"18998838518":{"samples":1,"sum":0.05157669999971404,"avg":0.05157669999971404}},"cancelRate":0.3333333333333333,"sumD":16.295907497406007,"sumI":1.4698621999996249,"sumDI":7.962961572044096,"plays":346,"deaths":0,"slope":0.08823753966042376,"conf":4,"max":0.5204860000012559,"sumDD":88.76938628083258,"distAvg":4.0739768743515019,"intercept":0.007987853973666359,"min":0.44923829999606826,"sum":1.9903482000008808,"cancels":1,"ema":0.500180835100713,"avg":0.4975870500002202,"kfTimestamp":10716.399344099998,"kfImpact":0.48750000000000007,"samples":4},"14327977958":{"plays":98,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"91370102211257":{"last":0.3904495000024326,"sumD":30.63448143005371,"sumI":1.202803900006984,"sumDI":12.24207485819208,"plays":33,"deaths":0,"conf":3,"max":0.4094078000052832,"samples":3,"distAvg":10.211493810017905,"intercept":0.4348568158101378,"min":0,"avg":0.4009346333356613,"sum":1.202803900006984,"misses":0,"cancels":0,"ema":0.4005543220014805,"sumDD":324.97017425151537,"slope":-0.003321960832135785},"9460808113":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17891413295":{"last":0.47706830000242919,"sumD":22.230228424072267,"sumI":1.4839873000018998,"sumDI":11.064969941043655,"sumDD":210.69879470207116,"plays":108,"deaths":0,"slope":0.001490306761286325,"conf":3,"max":0.5065512000001036,"samples":3,"distAvg":7.410076141357422,"intercept":0.4836191467588551,"min":0,"avg":0.4946624333339666,"sum":1.4839873000018998,"ema":0.4946764640004403,"misses":0,"kfTimestamp":10715.418670400002,"cancels":0,"kfImpact":0.541666653752327},"116326573759959":{"plays":125,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"10604657365":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14629528010":{"plays":59,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"114331643210589":{"plays":182,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"6748585142":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"88261348097917":{"plays":21,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.190980899999,"sum":0,"kfImpact":0.65},"113101872248044":{"plays":14,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"134944919039812":{"last":0.10024629999679746,"combo":{"16417788544":{"samples":3,"sum":0.3754831000005652,"avg":0.12516103333352172},"16417798771":{"samples":3,"sum":0.31346949999897336,"avg":0.10448983333299111},"18998838518":{"samples":76,"sum":11.101381099997525,"avg":0.14607080394733586},"101162579246421":{"samples":1,"sum":0.07605929999954242,"avg":0.07605929999954242},"123458031797396":{"samples":4,"sum":0.8598395000008168,"avg":0.2149598750002042},"13959320065":{"samples":3,"sum":0.6095261000009487,"avg":0.20317536666698289},"16417792446":{"samples":4,"sum":1.0338621999999305,"avg":0.2584655499999826},"119744649456014":{"samples":3,"sum":0.47246590000213475,"avg":0.15748863333404493},"17096539206":{"samples":2,"sum":0.30630959999871268,"avg":0.15315479999935634},"14597046093":{"samples":2,"sum":1.362767900000108,"avg":0.681383950000054}},"cancelRate":0.24649859943977593,"sumD":482.861212015152,"sumI":27.108660700022939,"calEma":0.3252276000021084,"successes":7,"ema":0.4171455410969214,"slope":0.01549529555953128,"misses":7,"sumDI":165.95290150737444,"calSum":0.6504552000042168,"plays":3604,"deaths":3,"avg":0.3828877788891128,"conf":99,"max":2.242115000000922,"samples":90,"distAvg":5.365124577946133,"intercept":0.21807315006238513,"min":0.053123600000162699,"cancels":88,"sum":34.45990010002015,"calAvg":0.3252276000021084,"sumDD":3914.3387570287675,"kfTimestamp":10716.096494700003,"kfImpact":3.25,"calSamples":2},"14774660926":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.609432199999,"sum":0,"kfImpact":0.541666653752327},"17732755849":{"last":0.5988385999953607,"sumD":23.51427698135376,"sumI":1.1846576999960235,"sumDI":13.982668421806203,"plays":155,"deaths":0,"conf":2,"max":0.5988385999953607,"samples":2,"distAvg":11.75713849067688,"cancels":0,"min":0,"sum":1.1846576999960235,"avg":0.5923288499980117,"ema":0.5897249499990721,"misses":0,"kfTimestamp":10716.3544558,"kfImpact":1.0941666305065157,"sumDD":311.4854241977321},"103319060602038":{"last":0.5469708000000537,"sumD":1.293657898902893,"sumI":0.5469708000000537,"sumDI":0.7075930958893041,"plays":263,"deaths":0,"conf":1,"max":0.5469708000000537,"samples":1,"distAvg":1.293657898902893,"cancels":0,"min":0,"avg":0.5469708000000537,"sum":0.5469708000000537,"ema":0.5469708000000537,"misses":0,"kfTimestamp":10716.520324600002,"kfImpact":1.083333307504654,"sumDD":1.673550759393848},"14024378591":{"plays":52,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.045963199998,"sum":0,"kfImpact":1.1207083106040957},"122680227249211":{"plays":25,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.206536500002,"sum":0,"kfImpact":0.65},"16927619274":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.176248099997,"sum":0,"kfImpact":1.0183333694934847},"11324326025":{"last":0.4269286999988253,"sumD":8.454971313476563,"sumI":0.5783798999982537,"sumDI":2.445092731388339,"plays":10,"deaths":0,"conf":2,"max":0.4269286999988253,"samples":2,"distAvg":4.227485656738281,"cancels":0,"min":0,"avg":0.28918994999912686,"sum":0.5783798999982537,"ema":0.23409444999924745,"misses":0,"kfTimestamp":10714.046469599998,"kfImpact":1.3649999380111695,"sumDD":35.743269955855797},"17162226428":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.669484899998,"sum":0,"kfImpact":0.8666666924953461},"14326697801":{"last":0.2666423000046052,"sumD":755.4641313552857,"sumI":35.241446800030647,"sumDI":366.48607753272298,"plays":6355,"deaths":0,"conf":75,"max":2.8121380000011415,"samples":75,"distAvg":10.072855084737143,"intercept":0.362471345947277,"min":0,"sumDD":8688.482189208717,"cancels":0,"ema":0.23765838036504595,"misses":0,"avg":0.46988595733374197,"sum":35.241446800030647,"slope":0.01066377015085073},"99447879815198":{"plays":3,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"82527686698091":{"plays":3185,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"106707347714801":{"last":0.1312236999947345,"sumD":714.8452272415161,"sumI":43.836151899980908,"sumDI":695.9385277758776,"plays":92,"deaths":1,"conf":50,"max":1.5710432000050787,"samples":47,"distAvg":15.209472920032259,"intercept":0.6489630398920085,"misses":0,"slope":0.018654232436458877,"avg":0.9326840829783172,"sumDD":12438.485305856728,"ema":0.5785589516332746,"min":0,"sum":43.836151899980908,"cancels":0},"130821883699985":{"last":0.5599951000185683,"sumD":75.04256582260132,"sumI":4.3619503999943849,"sumDI":41.06443833917965,"sumDD":1040.90988001476,"plays":174,"deaths":0,"slope":0.0004390222424106287,"conf":8,"max":0.5599951000185683,"samples":8,"distAvg":9.380320727825165,"intercept":0.5411256305588373,"min":0,"kfImpact":0.6933333694934846,"avg":0.5452437999992981,"ema":0.5447474616849067,"misses":0,"kfTimestamp":10718.284193200001,"sum":4.3619503999943849,"cancels":0},"9734469996":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.166720200003,"sum":0,"kfImpact":2.729999876022339},"10546190283":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17389531140":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"16301678355":{"plays":16,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9365257579":{"plays":89,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"79069029683112":{"plays":11,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.718998099997,"sum":0,"kfImpact":1.7983333230018617},"10105145484":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.099214599999,"sum":0,"kfImpact":2.047500061988831},"123716588791139":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.833075800001,"sum":0,"kfImpact":2.5350000619888308},"14629324978":{"plays":1785,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"100232105166419":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.0820924,"sum":0,"kfImpact":1.0291666924953463},"17759824327":{"plays":47,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.850040099998,"sum":0,"kfImpact":1.5274999380111696},"13268681873":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.892550800003,"sum":0,"kfImpact":1.5708333849906922},"14089528068":{"plays":3123,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"91766545966887":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11361464104":{"last":0.4877736999987974,"combo":{"18998838518":{"samples":4,"sum":0.36026439999841389,"avg":0.09006609999960347},"130216339682903":{"samples":5,"sum":1.0554838999996719,"avg":0.21109677999993438},"11361552631":{"samples":3,"sum":2.084976700003608,"avg":0.6949922333345361},"17096542398":{"samples":1,"sum":0.7673332000013033,"avg":0.7673332000013033}},"sumD":74.86730861663819,"sumI":5.156207200001518,"sumDI":38.41441333732108,"plays":704,"deaths":0,"conf":12,"max":0.5515430999985256,"samples":12,"distAvg":6.238942384719849,"intercept":0.25048872802786256,"min":0.48276459999760848,"slope":0.028722048426745297,"sum":6.151933800001643,"sumDD":684.5262614612852,"avg":0.5126611500001369,"kfTimestamp":10716.4145059,"kfImpact":0.48750000000000007,"ema":0.5091635940344771},"10529578994":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.010878699999,"sum":0,"kfImpact":0.8125},"17617778323":{"plays":217,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14174950477":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.4448377,"sum":0,"kfImpact":1.9391666769981384},"17757728943":{"plays":277,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"125555789564402":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"kfImpact":0.3333333432674408,"avg":0,"sum":0,"misses":0,"kfTimestamp":10713.5310369,"deaths":0,"cancels":0},"10233289802":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.739739600001,"sum":0,"kfImpact":0.9750000000000001},"11121384790":{"plays":91,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10715.6880342,"kfImpact":1.5816667079925538,"deaths":0},"14699824274":{"last":0.3525812000007136,"sumD":1621.658129453659,"sumI":30.82536079998681,"sumDI":488.5640492188991,"conf":105,"plays":26450,"deaths":0,"distAvg":15.444363137653897,"ema":0.6374256385017822,"max":2.0936320000037087,"samples":105,"slope":0.0016240305077524819,"intercept":0.26849274785342139,"min":0.054502500002854507,"distMax":29.91706085205078,"cancels":0,"avg":0.29357486476177915,"sumDD":32733.745892875224,"sum":30.82536079998681,"misses":0,"distMin":3.547078847885132},"18387092536":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.499724299996,"sum":0,"kfImpact":3.25},"136733734909381":{"plays":6335,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"106323240907104":{"plays":18,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.381844099997,"sum":0,"kfImpact":1.4625000000000002},"126131534219589":{"last":1.4923775000061142,"sumD":815.7141170501709,"sumI":46.05180780001683,"sumDI":747.7810328460578,"plays":115,"deaths":0,"conf":50,"max":1.4986930000013672,"samples":50,"distAvg":16.31428234100342,"intercept":0.9552224425178924,"min":0,"sumDD":14988.149282198458,"cancels":0,"ema":1.2269270531347452,"misses":0,"avg":0.9210361560003366,"sum":46.05180780001683,"slope":-0.002095482093725556},"136909500655901":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.300015599998,"sum":0,"kfImpact":0.8125},"137583635757354":{"plays":2,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"96796023393188":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9602662495":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5962345,"sum":0,"kfImpact":0.4983333230018616},"11384267129":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.873260200002,"sum":0,"kfImpact":0.7150000154972077},"11324326957":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.038992100002,"sum":0,"kfImpact":1.5274999380111696},"107271172226832":{"plays":15,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"79135580829944":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.827861700003,"sum":0,"kfImpact":1.6791666150093079},"10529642859":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.640439199997,"sum":0,"kfImpact":0.9099999845027924},"123563871643514":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"107844891272072":{"plays":51,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.448124499999,"sum":0,"kfImpact":0.65},"127359882437058":{"plays":7,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"109348958330538":{"plays":54,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"86823885833389":{"plays":28,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17150140878":{"last":0.4337928000022657,"sumD":271.2692265510559,"sumI":12.40081600000849,"sumDI":110.8623514822756,"kfImpact":0.9425000309944153,"plays":711,"deaths":0,"samples":30,"conf":30,"max":0.5973233999975491,"sumDD":3322.4867819896719,"distAvg":9.042307551701864,"intercept":0.42656275627818565,"min":0,"avg":0.41336053333361635,"sum":12.40081600000849,"misses":0,"ema":0.41482714735402029,"kfTimestamp":10717.104197100001,"cancels":0,"slope":-0.001460050199474194},"17096539206":{"last":0.4305424000049243,"combo":{"18998838518":{"samples":4,"sum":0.43968970000059928,"avg":0.10992242500014982},"14597046093":{"samples":2,"sum":0.8138560999996116,"avg":0.4069280499998058}},"sumD":560.9364898204804,"sumI":18.890949399965395,"sumDI":160.58496835170673,"plays":4610,"deaths":0,"ema":0.3318414530863438,"max":0.5636459000015748,"samples":69,"distAvg":8.129514345224353,"intercept":0.2529332315906861,"min":0.055412299996532968,"slope":0.0025645620249601568,"avg":0.2737818753618173,"sumDD":7293.833832920161,"sum":18.890949399965395,"misses":0,"conf":69,"cancels":0},"17389534922":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14629506290":{"last":0.9448855000009644,"sumD":94.31984519958496,"sumI":8.031611599995813,"sumDI":105.6294191662927,"plays":968,"deaths":1,"conf":10,"max":2.1985486000012317,"samples":7,"distAvg":13.47426359994071,"intercept":1.2047396466687417,"min":0,"sumDD":1879.3785173820016,"sum":8.031611599995813,"ema":1.0258868184551185,"cancels":0,"misses":0,"avg":1.1473730857136875,"slope":-0.00425749136712055},"16417788544":{"last":0.4618015999949421,"lastLearned":3016.1956565,"combo":{"18998838518":{"samples":13,"sum":1.4377235000029032,"avg":0.11059411538483871},"134944919039812":{"samples":2,"sum":0.2765406999988045,"avg":0.13827034999940225},"16417792446":{"samples":5,"sum":2.0803529000022538,"avg":0.4160705800004507}},"cancelRate":0.0851063829787234,"sumD":192.11600422859193,"sumI":10.298491399997602,"calEma":0.48698549999971876,"successes":8,"ema":0.35785763588525629,"sumDD":1985.077785487374,"sumDI":75.9465432247382,"calSum":0.9739709999994375,"plays":1029,"distAvg":5.821697097836119,"sum":14.636987299998964,"conf":33,"max":0.5021435999988171,"samples":33,"calAvg":0.48698549999971876,"intercept":0.20464906039870374,"misses":17,"avg":0.4435450696969383,"cancels":4,"min":0.1655520999993314,"slope":0.01845276983078528,"kfTimestamp":10716.017303100001,"kfImpact":0.5091666847467423,"calSamples":2},"17384025359":{"plays":408,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.338385299998,"sum":0,"kfImpact":0.9750000000000001},"14629233116":{"last":0.06713090000266675,"sumD":89.78879833221436,"sumI":0.6574865000075079,"sumDI":8.841441285735457,"plays":2723,"deaths":0,"conf":6,"max":0.19981800000095974,"samples":6,"distAvg":14.964799722035727,"intercept":0.1655598662070592,"min":0,"avg":0.10958108333458465,"sum":0.6574865000075079,"misses":0,"cancels":0,"ema":0.10311548413292417,"sumDD":1610.3897207823548,"slope":-0.0037406970966705019},"98251084212732":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.2294043,"sum":0,"kfImpact":1.1375},"9559359595":{"plays":63,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"85652792138826":{"last":0.662458399998286,"lastLearned":9485.908535,"combo":{"18998838518":{"samples":5,"sum":1.4620706000005158,"avg":0.29241412000010316},"18429789282":{"samples":1,"sum":0.1575052999996842,"avg":0.1575052999996842}},"successes":7,"calEma":0.29449334999844725,"calSum":0.5889866999968945,"plays":245,"deaths":0,"conf":5,"max":0.662458399998286,"samples":5,"calAvg":0.29449334999844725,"kfImpact":0.8775000154972077,"min":0.662458399998286,"misses":7,"cancels":0,"ema":0.7364583999982861,"avg":0.662458399998286,"kfTimestamp":10715.367525900001,"sum":3.31229199999143,"calSamples":2},"82136938563886":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.721304699997,"sum":0,"kfImpact":2.708333230018616},"16417803802":{"last":0.496330099995248,"combo":{"119744649456014":{"samples":1,"sum":0.18167039999934787,"avg":0.18167039999934787},"18998838518":{"samples":3,"sum":0.6102275999983249,"avg":0.20340919999944163},"16417798771":{"samples":1,"sum":0.0868996999997762,"avg":0.0868996999997762},"134944919039812":{"samples":3,"sum":0.60830949999945,"avg":0.20276983333315003},"17096539206":{"samples":3,"sum":0.6078082000021823,"avg":0.20260273333406077}},"sumD":79.52518582344055,"sumI":7.770745799992255,"sumDI":38.62494520859493,"slope":0.00005183841173082865,"kfImpact":0.6066666692495346,"deaths":0,"sum":7.770745799992255,"conf":16,"max":0.5039774999968358,"samples":16,"distAvg":4.9703241139650349,"intercept":0.48541395879166057,"misses":0,"avg":0.48567161249951598,"cancels":0,"min":0,"sumDD":430.374574592595,"kfTimestamp":10716.038963300001,"ema":0.4949293323263626,"plays":347},"9523146106":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"95706504932517":{"plays":2,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"71238401604624":{"plays":10,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"123934383054145":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18212119639":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.413583499998,"sum":0,"kfImpact":1.4083333849906923},"16300306071":{"plays":13,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"122889382192453":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.853250699998,"sum":0,"kfImpact":0.8666666924953461},"102209137660745":{"last":0.4820658000098774,"sumD":968.7080179452896,"sumI":77.75998880002226,"sumDI":487.06289015860258,"samples":149,"kfImpact":0.9641666769981384,"deaths":1,"distAvg":6.501396093592548,"conf":152,"max":0.7344540000049165,"sumDD":8522.188624122584,"slope":-0.008310994449802306,"intercept":0.5759121863130506,"min":0,"avg":0.5218791194632366,"sum":77.75998880002226,"ema":0.5423631748104104,"misses":0,"kfTimestamp":10715.486012200003,"cancels":0,"plays":5279},"130051946855819":{"plays":29,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"110660719971359":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18565843945":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.508132399998,"sum":0,"kfImpact":3.25},"17744158153":{"plays":3,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14085268099":{"last":0.4294228000071598,"sumD":464.70035886764529,"sumI":21.982321100000264,"sumDI":293.8112316733803,"plays":15515,"deaths":0,"conf":29,"max":2.8718619999999648,"samples":29,"distAvg":16.02415030578087,"intercept":1.1654723779108638,"min":0,"avg":0.7580110724138022,"sum":21.982321100000264,"misses":0,"cancels":0,"ema":0.3480762757540383,"sumDD":9744.56033031735,"slope":-0.025427950794374773},"86978856932820":{"plays":11,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.6909227,"sum":0,"kfImpact":1.0400000154972078},"80044202039051":{"last":0.5852086999948369,"combo":{"127153082609965":{"samples":1,"sum":0.050077300000339167,"avg":0.050077300000339167},"18429789282":{"samples":1,"sum":0.1418907000006584,"avg":0.1418907000006584}},"sumD":30.573923587799074,"sumI":2.5416314999965836,"sumDI":9.945910758282262,"plays":6019,"deaths":0,"ema":0.4153833663610508,"max":0.5852086999948369,"samples":8,"distAvg":3.821740448474884,"intercept":-0.24199626805251685,"min":0.08031829999526963,"slope":0.14645165287858456,"avg":0.31770393749957295,"cancels":0,"conf":8,"misses":0,"sum":2.5416314999965836,"sumDD":118.43284678140185},"17189206071":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17086023674":{"last":0.5409481000097003,"sumD":144.81421089172364,"sumI":7.870241000025999,"sumDI":110.98413674230828,"sumDD":2391.656732352799,"plays":235,"deaths":1,"slope":0.015196126121898172,"conf":14,"max":1.0840367999917362,"samples":11,"distAvg":13.164928262883967,"intercept":0.5154205442792915,"min":0,"kfImpact":0.7150000154972077,"avg":0.715476454547818,"ema":0.6170753566791336,"misses":0,"kfTimestamp":10716.8337369,"sum":7.870241000025999,"cancels":0},"17165729310":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.7660503,"sum":0,"kfImpact":0.8666666924953461},"124281421943100":{"last":0.7194362000154797,"sumD":11.66176986694336,"sumI":2.538225500000408,"sumDI":13.954591817998871,"plays":34,"deaths":0,"conf":2,"max":1.8187892999849283,"samples":2,"distAvg":5.83088493347168,"sumDD":69.18145814828358,"min":0,"kfImpact":2.275,"avg":1.269112750000204,"ema":1.4889833699940936,"misses":0,"kfTimestamp":10718.3247853,"sum":2.538225500000408,"cancels":0},"17799541604":{"plays":1,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"116142638412795":{"last":0.38956490000418855,"sumD":2453.3951897621157,"sumI":81.54217329994845,"sumDI":983.5959065730584,"plays":2090,"deaths":0,"conf":162,"max":1.38312279999991,"samples":162,"distAvg":15.144414751617998,"intercept":0.7812462540649131,"min":0,"slope":-0.018349966628463413,"cancels":0,"sumDD":50850.76796390925,"ema":0.5160994416030492,"misses":0,"avg":0.5033467487651139,"sum":81.54217329994845},"11110116582":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.087238699998,"sum":0,"kfImpact":1.8199999690055849},"135523955943242":{"plays":4,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14410995942":{"plays":3646,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17891445162":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.2663732,"sum":0,"kfImpact":0.541666653752327},"9695313793":{"plays":80,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"80651761610614":{"plays":96,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.1951215,"sum":0,"kfImpact":1.3324999690055848},"18112589804":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.390077299999,"sum":0,"kfImpact":1.4300000309944155},"103947541689479":{"plays":2,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"127410288003428":{"plays":4,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"101612904089734":{"plays":13,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"130997038484054":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"93171197895224":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.928565499999,"sum":0,"kfImpact":2.3725000619888307},"9753861902":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.898054199999,"sum":0,"kfImpact":1.8308332920074464},"9875184664":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.867841300002,"sum":0,"kfImpact":0.7150000154972077},"14580994889":{"plays":1104,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"84523300592719":{"last":0.5407152000116184,"sumD":16.951624155044557,"sumI":1.572294099983992,"sumDI":9.066567254835766,"sumDD":125.33189314846692,"plays":25,"deaths":0,"slope":0.006168487474922699,"conf":3,"max":0.5792392999865115,"samples":3,"distAvg":5.650541385014852,"intercept":0.48924273956800087,"min":0,"kfImpact":0.8233333230018616,"avg":0.5240980333279973,"ema":0.5055012169937253,"misses":0,"kfTimestamp":10718.810953100001,"sum":1.572294099983992,"cancels":0},"71134901979127":{"plays":15,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14597046093":{"last":0.9715487999928882,"combo":{"130216339682903":{"samples":3,"sum":0.6029508999999962,"avg":0.20098363333333206},"81281779521042":{"samples":2,"sum":0.8276834999996936,"avg":0.4138417499998468},"115338865375824":{"samples":1,"sum":0.055433800000173508,"avg":0.055433800000173508},"101464977033970":{"samples":1,"sum":0.10556999999971595,"avg":0.10556999999971595},"72352073483435":{"samples":1,"sum":0.10183150000011665,"avg":0.10183150000011665},"123458031797396":{"samples":1,"sum":0.7695439999988594,"avg":0.7695439999988594},"11361464104":{"samples":1,"sum":0.9610659999998461,"avg":0.9610659999998461},"17096539206":{"samples":1,"sum":0.13883410000016739,"avg":0.13883410000016739},"113631162072406":{"samples":1,"sum":0.2003895999987435,"avg":0.2003895999987435},"16417788544":{"samples":1,"sum":0.15759330000037154,"avg":0.15759330000037154},"18998838518":{"samples":44,"sum":10.450685600006182,"avg":0.2375155818183223},"101162579246421":{"samples":1,"sum":0.0738578000000416,"avg":0.0738578000000416},"119333842262474":{"samples":1,"sum":0.12299660000098811,"avg":0.12299660000098811},"17096542398":{"samples":1,"sum":0.09401090000028489,"avg":0.09401090000028489},"18429789282":{"samples":4,"sum":1.2847460999983014,"avg":0.32118652499957536},"134944919039812":{"samples":2,"sum":0.12818610000249465,"avg":0.06409305000124732},"128875759494501":{"samples":3,"sum":2.222144199999093,"avg":0.740714733333031}},"cancelRate":0.2692307692307692,"sumD":232.9182596206665,"sumI":7.020900499999698,"sumDI":75.54871981954359,"plays":29064,"kfImpact":0.43333334624767308,"deaths":0,"samples":13,"ema":0.5288321689957918,"max":2.7501435999984098,"sumDD":4840.937629274872,"distAvg":17.91678920158973,"intercept":1.8880945353206114,"misses":2,"sum":7.020900499999698,"cancels":7,"min":0.05109470000024885,"conf":13,"kfTimestamp":10713.6165377,"avg":0.5400692692307459,"slope":-0.0752381049373655},"10556985207":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"99982935979056":{"plays":13,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"98238404943510":{"last":0.4474679999984801,"sumD":28.358976364135743,"sumI":0.4474679999984801,"sumDI":12.68973443566399,"plays":67,"deaths":0,"conf":1,"max":0.4474679999984801,"samples":1,"distAvg":28.358976364135743,"misses":0,"avg":0.4474679999984801,"sumDD":804.2315404216097,"ema":0.44746799999848,"min":0,"sum":0.4474679999984801,"cancels":0},"83405312344134":{"plays":75,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9684147213":{"last":0.442028700002993,"sumD":7.172842979431152,"sumI":0.442028700002993,"sumDI":3.170602457523547,"plays":3732,"deaths":0,"conf":1,"max":0.442028700002993,"samples":1,"distAvg":7.172842979431152,"sumDD":51.44967640757477,"min":0,"kfImpact":0.8775000154972077,"cancels":0,"ema":0.442028700002993,"misses":0,"kfTimestamp":10715.961133199999,"avg":0.442028700002993,"sum":0.442028700002993},"6748146529":{"last":0.12829020000208403,"sumD":4.547983169555664,"sumI":0.12829020000208403,"sumDI":0.5834616704284081,"plays":5982,"deaths":0,"conf":1,"max":0.12829020000208403,"samples":1,"distAvg":4.547983169555664,"min":0,"cancels":0,"sum":0.12829020000208403,"avg":0.12829020000208403,"misses":0,"ema":0.12829020000208403,"sumDD":20.684150910561585},"101464977033970":{"last":2.3060267999971986,"lastLearned":9490.287895800002,"combo":{"113631162072406":{"samples":1,"sum":0.07484850000037113,"avg":0.07484850000037113},"134944919039812":{"samples":1,"sum":0.09861529999943741,"avg":0.09861529999943741},"18429789282":{"samples":20,"sum":3.9636558999973205,"avg":0.19818279499986603}},"sumD":383.2483813762665,"sumI":165.28655340000024,"calEma":0.4807900999985577,"successes":12,"sumDI":880.5578672265607,"calSum":0.4807900999985577,"plays":164,"deaths":41,"slope":0.14269603570104556,"conf":212,"max":2.3837184000003619,"samples":89,"distAvg":4.3061615884973769,"intercept":1.2426800976265685,"misses":18,"avg":2.2984013033707897,"sum":204.55771600000026,"min":2.0006699999939885,"ema":2.2947988668411747,"sumDD":2833.31438926383,"calAvg":0.4807900999985577,"calSamples":1},"14327924170":{"last":0.658626499993261,"sumD":148.42612171173097,"sumI":14.619091999988996,"sumDI":87.74379505615615,"kfImpact":0.8775000154972077,"plays":817,"deaths":0,"samples":25,"conf":25,"max":1.0377510999969673,"sumDD":950.0454326386198,"distAvg":5.937044868469238,"intercept":0.5028586768823505,"min":0,"cancels":0,"avg":0.5847636799995598,"misses":0,"ema":0.7736709844780647,"kfTimestamp":10715.705243700002,"sum":14.619091999988996,"slope":0.01379558432380975},"139167828097095":{"last":1.3811746000137646,"sumD":14.35932445526123,"sumI":2.759020900033647,"sumDI":19.808838141215,"plays":46,"deaths":1,"conf":5,"max":1.3811746000137646,"samples":2,"distAvg":7.179662227630615,"misses":0,"avg":1.3795104500168237,"sumDD":103.09509940573162,"ema":1.3788447900180472,"min":0,"sum":2.759020900033647,"cancels":0},"91233168287060":{"last":0.07812420000846032,"lastLearned":9684.635499000002,"combo":{"18998838518":{"samples":2,"sum":0.15624690000004194,"avg":0.07812345000002097},"72352073483435":{"samples":2,"sum":0.3017096000003221,"avg":0.15085480000016106}},"cancelRate":0.36363636363636367,"sumD":318.346267580986,"sumI":23.99755650004954,"ema":0.30774423767140227,"sumDI":131.9791986931734,"samples":69,"kfImpact":0.9750000000000001,"deaths":0,"slope":0.017245325342260536,"conf":69,"max":0.7890184000007139,"sumDD":2701.6339445813,"distAvg":4.613714022912841,"intercept":0.26822567455247989,"misses":14,"min":0.050463999999919909,"sum":29.608895400060648,"avg":0.42911442608783548,"cancels":12,"kfTimestamp":10715.301059600002,"plays":7334,"successes":10},"135706026150442":{"plays":440,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"76754008387126":{"last":0.4882260000013048,"lastLearned":9686.2227463,"combo":{"18998838518":{"samples":1,"sum":0.06567050000012387,"avg":0.06567050000012387}},"cancelRate":0.16,"sumD":76.99260830879212,"sumI":6.682760700001381,"conf":25,"sumDI":36.611343823406517,"distAvg":3.0797043323516846,"plays":3832,"deaths":0,"misses":13,"ema":0.47897017769005958,"max":0.5002754999950412,"samples":25,"slope":0.06634038745286895,"intercept":0.06300164935156541,"min":0.432265000003099,"sum":11.796660300004078,"avg":0.4718664120001631,"sumDD":478.75334666439388,"cancels":4,"kfTimestamp":10715.288303499998,"kfImpact":0.9750000000000001,"successes":4},"18775503709":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.550690299999,"sum":0,"kfImpact":1.1483333230018616},"135534490442184":{"plays":6,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"109162896875607":{"plays":1,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"92272063398072":{"plays":23,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"108402061040328":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.3245819,"sum":0,"kfImpact":1.2675000309944154},"18772814845":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"131520466977363":{"plays":20,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"72997946136762":{"plays":89,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"108328830898212":{"last":0.7227215000020806,"sumD":301.38697814941409,"sumI":35.246956099930688,"sumDI":375.07446170989047,"plays":1071,"deaths":0,"conf":26,"max":2.920522799991886,"samples":26,"distAvg":11.591806851900542,"intercept":5.356051243382718,"min":0,"slope":-0.3451057403563612,"sum":35.246956099930688,"sumDD":3590.695524412473,"ema":0.999626392810004,"misses":0,"avg":1.3556521576896417,"cancels":0},"89900583582792":{"last":0.9457584000192583,"sumD":42.04756259918213,"sumI":2.7945178000081798,"sumDI":39.375937179214769,"plays":118,"deaths":0,"conf":3,"max":0.9457584000192583,"samples":3,"distAvg":14.015854199727377,"intercept":0.9099244429751345,"misses":0,"slope":0.0015397913001510146,"avg":0.9315059333360599,"sumDD":724.6645714795459,"ema":0.9348178900024504,"min":0,"sum":2.7945178000081798,"cancels":0},"91983451624365":{"last":0.6950512999901548,"sumD":47.824275970458987,"sumI":1.8341812999933609,"sumDI":21.487994079183435,"kfImpact":1.061666661500931,"plays":217,"deaths":0,"samples":4,"conf":4,"max":0.6950512999901548,"sumDD":580.7201657699516,"distAvg":11.956068992614746,"intercept":1.049805543721012,"min":0,"cancels":0,"avg":0.4585453249983402,"misses":0,"ema":0.525854036797762,"kfTimestamp":10715.1342181,"sum":1.8341812999933609,"slope":-0.04945272723734639},"138644029603579":{"plays":92,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"114718392521443":{"last":0.9757249999966007,"sumD":7.567971229553223,"sumI":0.9757249999966007,"sumDI":7.384258727930092,"plays":51,"deaths":0,"conf":1,"max":0.9757249999966007,"samples":1,"distAvg":7.567971229553223,"misses":0,"avg":0.9757249999966007,"sumDD":57.27418853134532,"ema":0.9757249999966007,"min":0,"sum":0.9757249999966007,"cancels":0},"105929615471866":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.223581799997,"sum":0,"kfImpact":0.7908333539962769},"89799250368182":{"last":0.39926869998453187,"sumD":461.1664260625839,"sumI":40.385289499827198,"sumDI":377.3880493116143,"plays":1000,"deaths":1,"conf":51,"max":1.6784970999869984,"samples":48,"distAvg":9.607633876303832,"intercept":0.8810964533658332,"misses":0,"slope":-0.004135904423957259,"avg":0.8413601979130666,"sumDD":6998.2403209964299,"ema":0.642750337274229,"min":0,"sum":40.385289499827198,"cancels":0},"17109178988":{"plays":55,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.2216406,"sum":0,"kfImpact":1.0291666924953463},"17154399253":{"last":0.4890765000018291,"sumD":18.88067054748535,"sumI":1.0000640000071144,"sumDI":9.464279237291608,"plays":80,"deaths":0,"conf":2,"max":0.5109875000052853,"samples":2,"distAvg":9.440335273742676,"sumDD":180.50919818158037,"min":0,"kfImpact":0.541666653752327,"cancels":0,"ema":0.5044142000042484,"misses":0,"kfTimestamp":10715.411544199997,"avg":0.5000320000035572,"sum":1.0000640000071144},"6950900750":{"plays":80,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"135179392622334":{"last":0.3420386000070721,"sumD":10.371640682220459,"sumI":2.5008971999923235,"sumDI":13.531537911421083,"plays":1482,"deaths":0,"conf":2,"max":2.158858599985251,"samples":2,"distAvg":5.1858203411102299,"misses":0,"avg":1.2504485999961617,"sumDD":53.97706517577012,"ema":1.6138125999917974,"min":0,"sum":2.5008971999923235,"cancels":0},"86509163598473":{"plays":126,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"98267058265862":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"140223371973489":{"plays":22,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.8019699,"sum":0,"kfImpact":0.7908333539962769},"99939565896819":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.229104500002,"sum":0,"kfImpact":1.1266666769981384},"113122622053882":{"plays":67,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14629239924":{"last":0.16965909999998986,"sumD":12.376301765441895,"sumI":0.22787590000370984,"sumDI":1.0533828479906969,"plays":2726,"deaths":0,"conf":2,"max":0.16965909999998986,"samples":2,"distAvg":6.188150882720947,"min":0,"sum":0.22787590000370984,"avg":0.11393795000185492,"misses":0,"cancels":0,"ema":0.09164949000260095,"sumDD":97.0816147199339},"12357922879":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11156433078":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"74204075432091":{"last":1.3201464000012493,"sumD":10.000054359436036,"sumI":10.98117160000038,"sumDI":8.839086376747652,"plays":142,"deaths":2,"conf":12,"max":2.30489800000214,"samples":6,"distAvg":1.6666757265726727,"intercept":2.3033409835879925,"min":0,"sum":10.98117160000038,"cancels":0,"avg":1.83019526666673,"misses":0,"ema":1.6187085109378348,"sumDD":50.00054359586693,"slope":-0.2838858869650861},"78841924930006":{"last":0.5045712999999523,"sumD":711.9353431463242,"sumI":55.812083499957228,"sumDI":416.8042135057652,"plays":23510,"deaths":2,"conf":113,"max":2.247551000000385,"samples":107,"distAvg":6.653601337816114,"intercept":0.31842949494435737,"min":0,"sum":55.812083499957228,"avg":0.5216082570089461,"misses":0,"cancels":0,"ema":0.5538270666973763,"sumDD":6225.402566413234,"slope":0.03053666003549249},"96020812931018":{"last":0.9123137999995379,"sumD":4.181759357452393,"sumI":0.9123137999995379,"sumDI":3.815076770081018,"plays":753,"deaths":0,"conf":1,"max":0.9123137999995379,"samples":1,"distAvg":4.181759357452393,"cancels":0,"min":0,"avg":0.9123137999995379,"sum":0.9123137999995379,"ema":0.9123137999995379,"misses":0,"kfTimestamp":10715.360724600003,"kfImpact":0.7041666924953461,"sumDD":17.487111323640649},"77018334356015":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11637455978":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.9911812,"sum":0,"kfImpact":2.1125000000000004},"91552133043710":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"93135336110774":{"plays":53,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"125731355555983":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"115763483372897":{"plays":10,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"93227313880429":{"plays":59,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"15599747190":{"plays":767,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"96766736035258":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18983655582":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"124214457067503":{"plays":197,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10104034248":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.121961600002,"sum":0,"kfImpact":1.516666615009308},"18554782660":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14040195659":{"plays":2286,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11384233387":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.865994799999,"sum":0,"kfImpact":0.6174999922513962},"127024975168411":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13905824816":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"136719704224362":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"108033881657657":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"91823403446598":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18147748330":{"plays":13,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14327026699":{"plays":195,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.7591273,"sum":0,"kfImpact":1.8524999380111696},"9535459100":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17429351656":{"plays":20,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.252984799998,"sum":0,"kfImpact":0.6283333152532578},"83450269786196":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.252087699999,"sum":0,"kfImpact":0.9966666460037232},"121875335012202":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"90883933480570":{"last":0.646933900003205,"sumD":453.64676213264468,"sumI":46.616884900053268,"sumDI":251.5374366683031,"plays":3392,"kfImpact":0.9641666769981384,"deaths":2,"sumDD":2759.472119639264,"conf":90,"max":0.9842366999946535,"samples":84,"slope":-0.000709770058952361,"intercept":0.5587960689185203,"min":0,"avg":0.5549629154768245,"sum":46.616884900053268,"misses":0,"ema":0.6400363099744184,"kfTimestamp":10715.554821899997,"cancels":0,"distAvg":5.400556692055294},"14628825012":{"last":0.41435379999893487,"sumD":0.44282060861587527,"sumI":1.311507199992775,"sumDI":0.19032731085738706,"kfImpact":1.6141666769981385,"plays":683,"deaths":0,"avg":0.4371690666642583,"conf":3,"max":0.4517904999956954,"sumDD":0.0789757988699229,"slope":-0.23949875943280936,"intercept":0.47252072880251957,"min":0,"cancels":0,"sum":1.311507199992775,"misses":0,"ema":0.4374099659978673,"kfTimestamp":10715.4785261,"distAvg":0.1476068695386251,"samples":3},"80849774781383":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"79812617011366":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"104856245052955":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.1113702,"sum":0,"kfImpact":0.8125},"9684150459":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18444010072":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"86253063460166":{"last":0.10389639998902567,"sumD":126.08415126800537,"sumI":0.7652766999672167,"sumDI":9.679511097662392,"plays":7504,"deaths":1,"conf":13,"max":0.10389639998902567,"samples":10,"distAvg":12.608415126800537,"intercept":0.05201537547578724,"min":0,"avg":0.07652766999672167,"sum":0.7652766999672167,"misses":0,"cancels":0,"ema":0.08414629507510721,"sumDD":1605.453244838599,"slope":0.0019441217848888023},"139243650107688":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"91276593220093":{"last":0.295371599997452,"combo":{"18998838518":{"samples":11,"sum":1.3102214999998978,"avg":0.11911104545453616},"119333842262474":{"samples":2,"sum":0.2973089000006439,"avg":0.14865445000032197},"115338865375824":{"samples":2,"sum":0.11901070000021719,"avg":0.05950535000010859},"113631162072406":{"samples":2,"sum":0.33455660000072387,"avg":0.16727830000036193}},"cancelRate":0.5259259259259259,"sumD":206.56209468841554,"sumI":10.961423999989848,"sumDI":93.2961745944571,"slope":0.025927355955781708,"kfImpact":2.166666615009308,"deaths":0,"sum":12.425291699990112,"conf":32,"max":0.8156024999989313,"samples":32,"distAvg":6.455065459012985,"intercept":0.17518172012598164,"misses":3,"cancels":71,"avg":0.388290365624691,"ema":0.3860843186230718,"sumDD":2202.7032618179175,"kfTimestamp":10715.698404100003,"min":0.056544300001405648,"plays":3074},"18791446076":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.5658473,"sum":0,"kfImpact":1.083333307504654},"129343427417751":{"plays":24,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"136687466948328":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"93042352046889":{"last":0.39054929999110757,"sumD":14.452098846435547,"sumI":0.39054929999110757,"sumDI":5.644257087877696,"plays":442,"deaths":0,"conf":1,"max":0.39054929999110757,"samples":1,"distAvg":14.452098846435547,"sumDD":208.86316106714367,"min":0,"kfImpact":0.39000001549720766,"avg":0.39054929999110757,"ema":0.39054929999110757,"misses":0,"kfTimestamp":10715.879961500003,"cancels":0,"sum":0.39054929999110757},"14327905929":{"last":0.6599017999978969,"sumD":208.32337844371797,"sumI":19.332577499973014,"sumDI":122.12802722786222,"sumDD":1533.3525288223933,"plays":1410,"deaths":1,"slope":0.03128107204338115,"conf":39,"max":0.6829454999970039,"samples":36,"distAvg":5.786760512325499,"intercept":0.35599996918206985,"min":0,"avg":0.537016041665917,"sum":19.332577499973014,"ema":0.6337135023649608,"misses":0,"kfTimestamp":10715.715416799998,"cancels":0,"kfImpact":0.8775000154972077},"10673669649":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11151745461":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"137401035174373":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.089321699998,"sum":0,"kfImpact":1.0291666924953463},"134018502055402":{"plays":13,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18958341833":{"last":0.10316210000019055,"sumD":688.7784852981567,"sumI":31.019113100023789,"sumDI":149.4482110573667,"plays":72627,"deaths":0,"conf":121,"max":1.6940325000014128,"samples":121,"distAvg":5.692384176017824,"intercept":0.29516147824511415,"misses":0,"slope":-0.006817033150509167,"avg":0.2583590495869806,"cancels":0,"sum":31.26144500002465,"min":0,"ema":0.18969690123658396,"sumDD":7899.721720239193},"14326715025":{"plays":7434,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"107507023089925":{"last":0.7679833000001963,"sumD":495.4565372467041,"sumI":12.969120799991288,"sumDI":298.99065265379678,"plays":2057,"deaths":0,"conf":23,"max":0.9429832999958308,"samples":23,"distAvg":21.541588575943658,"intercept":0.3390980687830506,"min":0,"slope":0.01043454839996768,"cancels":0,"sumDD":12552.751943525178,"ema":0.8070246153916103,"misses":0,"avg":0.5638748173909256,"sum":12.969120799991288},"6940137765":{"plays":3697,"last":0,"ema":0.05,"max":0,"samples":0,"min":{"m":null,"t":"numeric","v":"inf"},"sum":0,"conf":0,"misses":2,"cancels":0,"deaths":0,"avg":0},"86850231217100":{"last":1.0469424000038999,"sumD":760.1863102912903,"sumI":48.15085320008802,"sumDI":434.17638483356356,"plays":158,"deaths":1,"conf":92,"max":1.2132484999892768,"samples":89,"distAvg":8.54141921675607,"intercept":0.43686227147048509,"min":0,"sum":48.15085320008802,"avg":0.5410208224728992,"misses":0,"cancels":0,"ema":0.7516551518058903,"sumDD":8370.942350544334,"slope":0.012194525096963012},"14708945367":{"plays":40,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9844571694":{"plays":573,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"combo":{"18998838518":{"samples":1,"sum":0.1635839999999007,"avg":0.1635839999999007},"9465728971":{"samples":2,"sum":0.3708041999980196,"avg":0.1854020999990098},"136583255994029":{"samples":2,"sum":0.504138200001762,"avg":0.252069100000881}},"misses":0,"cancels":0,"deaths":0,"avg":0},"115495827589598":{"last":1.3710233999954654,"sumD":160.5486946105957,"sumI":22.133770499998719,"sumDI":248.3938093743216,"plays":798,"deaths":0,"conf":14,"max":2.122088000000076,"samples":14,"distAvg":11.467763900756836,"intercept":1.653256641759765,"min":0,"slope":-0.006302277867111452,"cancels":0,"sum":22.133770499998719,"avg":1.5809836071427657,"misses":0,"ema":1.4662910442341544,"sumDD":2702.8935689110455},"85780218127180":{"plays":22,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"140098173852774":{"last":0.15047119998780546,"sumD":590.7902327775955,"sumI":28.17080600000827,"sumDI":264.57512127218987,"plays":20477,"kfImpact":0.4008333384990692,"deaths":0,"avg":0.3275675116280031,"conf":86,"max":2.677051599996048,"samples":86,"distAvg":6.869653869506925,"intercept":0.17400184736680003,"min":0,"cancels":0,"sum":28.17080600000827,"misses":0,"ema":0.5376435867856207,"kfTimestamp":10716.491599499997,"slope":0.0223542069481625,"sumDD":7236.961245718641},"14564868718":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"127367360034401":{"last":0.7298790000058943,"sumD":216.36105823516847,"sumI":8.138876299999538,"sumDI":145.18351081728719,"plays":143,"deaths":1,"conf":15,"max":0.7298790000058943,"samples":12,"distAvg":18.030088186264039,"intercept":0.7048332196167855,"misses":0,"slope":-0.001474952738745735,"avg":0.6782396916666281,"sumDD":4959.4473545788719,"ema":0.7029444943789898,"min":0,"sum":8.138876299999538,"cancels":0},"19002225918":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10517478449":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.785253200003,"sum":0,"kfImpact":2.123333323001862},"130719155551615":{"plays":15,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"81942880960967":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"129477723938251":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13840350747":{"plays":608,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"136816311133870":{"plays":36,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"121559768488375":{"plays":141,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"127232666335591":{"plays":49,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.2134448,"sum":0,"kfImpact":0.6608333230018616},"83118719637202":{"plays":15,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.684341799999,"sum":0,"kfImpact":3.25},"80804878487892":{"plays":373,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"102813187141061":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18282543938":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"71629946324744":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"71081429380094":{"last":1.834074700003839,"sumD":504.85458040237429,"sumI":65.6655604000407,"sumDI":721.6710727438368,"plays":1100,"deaths":0,"conf":45,"max":2.2393475999997465,"samples":45,"distAvg":11.218990675608318,"intercept":1.9326181212480025,"min":0,"slope":-0.04219483368684364,"sum":65.6655604000407,"sumDD":6020.169194695792,"ema":1.461455011768932,"misses":0,"avg":1.45923467555646,"cancels":0},"12130625590":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"94860056861084":{"last":0.06677000000490807,"sumD":16.076618194580079,"successes":5,"sumDI":1.073435796931017,"plays":614,"deaths":0,"kfImpact":1.375833261013031,"ema":0.06677000000490807,"max":0.06677000000490807,"sumDD":258.4576525743032,"distAvg":16.076618194580079,"avg":0.06677000000490807,"min":0,"sum":0.06677000000490807,"cancels":0,"misses":0,"conf":1,"kfTimestamp":10716.6756791,"sumI":0.06677000000490807,"samples":1},"102224781059994":{"plays":74,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"129752758393917":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14089521212":{"last":0.17114480000600452,"sumD":48.070974826812747,"sumI":0.7689217000224744,"sumDI":6.202159946193625,"plays":2953,"deaths":0,"conf":6,"max":0.19746470000245609,"samples":6,"distAvg":8.011829137802124,"intercept":0.08153148159766176,"min":0,"sum":0.7689217000224744,"avg":0.1281536166704124,"misses":0,"cancels":0,"ema":0.12983862798528598,"sumDD":392.3008123959596,"slope":0.005819162424816819},"101162579246421":{"last":0.3041891999891959,"combo":{"130216339682903":{"samples":1,"sum":0.20162859999982175,"avg":0.20162859999982175},"70967133952711":{"samples":1,"sum":0.20049380000091333,"avg":0.20049380000091333},"18998838518":{"samples":7,"sum":0.8438315999992483,"avg":0.12054737142846404},"134944919039812":{"samples":2,"sum":0.140483299999687,"avg":0.0702416499998435},"127153082609965":{"samples":1,"sum":0.15169939999941563,"avg":0.15169939999941563}},"sumD":121.9543035030365,"sumI":2.598157899979469,"sumDI":26.37129736870675,"plays":5951,"deaths":0,"ema":0.22348327432291599,"max":0.4808420999979717,"samples":12,"distAvg":10.162858625253043,"intercept":0.21712524523564759,"min":0,"slope":-0.000060227828271094479,"cancels":0,"sumDD":1794.1986293486733,"sum":2.598157899979469,"misses":0,"conf":12,"avg":0.21651315833162244},"18983643529":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14411214586":{"plays":495,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17138937724":{"last":0.8167205999998259,"sumD":3143.1157302856447,"sumI":252.78967799994099,"sumDI":3614.1412939124818,"plays":712,"deaths":2,"conf":228,"max":2.549235700000281,"samples":222,"distAvg":14.15817896525065,"intercept":1.0987152114132897,"min":0,"avg":1.1386922432429774,"sum":252.78967799994099,"misses":0,"cancels":0,"ema":1.0680022229305196,"sumDD":56931.66137205022,"slope":0.0028235998377903004},"129602691997469":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"104694319353269":{"last":0.17417050000221935,"sumD":108.52514219284058,"sumI":10.172372699997596,"sumDI":49.09802736484104,"kfImpact":0.8666666924953461,"plays":2488,"deaths":0,"cancels":0,"conf":22,"max":0.8348929999920074,"sumDD":553.545188549165,"slope":-0.05946121764792968,"intercept":0.7557004454635729,"min":0,"avg":0.46238057727261797,"sum":10.172372699997596,"misses":0,"ema":0.4532129837694171,"kfTimestamp":10716.479200599999,"distAvg":4.9329610087654809,"samples":22},"9663812307":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.269356999997,"sum":0,"kfImpact":0.19500000774860383},"13912276004":{"plays":73,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.802328600003,"sum":0,"kfImpact":3.25},"14484805190":{"plays":100,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"95428910954506":{"plays":58,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"85599301703737":{"plays":202,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.230487399996,"sum":0,"kfImpact":1.0400000154972078},"13268678901":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.908902900002,"sum":0,"kfImpact":1.8091666460037233},"70967133952711":{"plays":419,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"combo":{"18998838518":{"samples":1,"sum":0.07436479999887524,"avg":0.07436479999887524},"130216339682903":{"samples":16,"sum":3.255655500002831,"avg":0.20347846875017695},"101162579246421":{"samples":1,"sum":0.16600990000006278,"avg":0.16600990000006278},"16417798771":{"samples":3,"sum":0.5883145999996486,"avg":0.19610486666654956}},"avg":0,"deaths":0,"cancels":0,"misses":0},"15304242275":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.5113556,"sum":0,"kfImpact":0.2708333268761635},"113739873056325":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"82208537198225":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.198116200001,"sum":0,"kfImpact":0.7908333539962769},"16363599075":{"plays":28,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14110203809":{"plays":339,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.4524591,"sum":0,"kfImpact":1.1808333694934846},"123688081756316":{"last":0.7850343999998586,"sumD":14.243714332580567,"sumI":0.7850343999998586,"sumDI":11.18180573484677,"plays":4,"deaths":0,"conf":1,"max":0.7850343999998586,"samples":1,"distAvg":14.243714332580567,"misses":0,"avg":0.7850343999998586,"cancels":0,"sum":0.7850343999998586,"min":0,"ema":0.7850343999998585,"sumDD":202.88339798816106},"110047877378582":{"last":0.3235715999981039,"sumD":119.4752721786499,"sumI":39.51862540001093,"sumDI":290.2209907420804,"plays":1689,"deaths":0,"conf":16,"max":2.993226100003085,"samples":16,"distAvg":7.467204511165619,"intercept":3.304899541519113,"min":0,"slope":-0.11182035429321458,"sum":39.51862540001093,"sumDD":935.7221425863445,"ema":1.8123379459943876,"misses":0,"avg":2.4699140875006835,"cancels":0},"136583255994029":{"last":0.3406408000009833,"combo":{"130216339682903":{"samples":41,"sum":12.272773900001994,"avg":0.29933594878053645},"18998838518":{"samples":15,"sum":2.6929168999995456,"avg":0.17952779333330302},"128875759494501":{"samples":1,"sum":0.20070830000076968,"avg":0.20070830000076968},"101464977033970":{"samples":1,"sum":0.10419569999794476,"avg":0.10419569999794476},"101162579246421":{"samples":1,"sum":0.16656089999924007,"avg":0.16656089999924007},"6940137765":{"samples":1,"sum":0.15897469999981696,"avg":0.15897469999981696},"11361464104":{"samples":5,"sum":1.9586179000016273,"avg":0.3917235800003255},"11361552631":{"samples":2,"sum":1.5572314000000916,"avg":0.7786157000000458},"11497886799":{"samples":1,"sum":0.05898270000034245,"avg":0.05898270000034245},"11151794033":{"samples":1,"sum":0.2694469999987632,"avg":0.2694469999987632},"14597046093":{"samples":7,"sum":2.7620488999982628,"avg":0.3945784142854661}},"cancelRate":0.23529411764705883,"sumD":283.0457594394684,"sumI":14.292052300011165,"sumDI":117.48657994859296,"samples":37,"kfImpact":1.0400000154972078,"deaths":0,"distAvg":7.6498853902559029,"conf":37,"max":1.0834599000008894,"sumDD":3360.9677385818297,"slope":0.006819450575133208,"intercept":0.33410366845980185,"misses":1,"avg":0.3862716837840855,"cancels":32,"min":0,"sum":14.292052300011165,"kfTimestamp":10716.423896300003,"ema":0.3406299596697297,"plays":3426},"115243896458508":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.569929199999,"sum":0,"kfImpact":1.1375},"14326949964":{"plays":251,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17139363450":{"last":0.09152449999965029,"sumD":15.175752639770508,"sumI":0.09152449999965029,"sumDI":1.3889531724733689,"plays":46,"deaths":0,"conf":1,"max":0.09152449999965029,"samples":1,"distAvg":15.175752639770508,"min":0,"sum":0.09152449999965029,"sumDD":230.30346818350155,"ema":0.09152449999965029,"cancels":0,"misses":0,"avg":0.09152449999965029},"17188386684":{"last":0.17955789998813999,"sumD":5351.088188648224,"sumI":309.57163009990566,"sumDI":2581.4065212549155,"samples":617,"kfImpact":1.2675000309944154,"deaths":4,"distAvg":8.672752331682697,"conf":629,"max":1.5317218999989564,"sumDD":64596.15899305664,"slope":-0.00568695949587024,"intercept":0.5510584309361065,"min":0,"cancels":0,"avg":0.5017368397081129,"ema":0.33020032663175666,"misses":0,"kfTimestamp":10717.190783699996,"sum":309.57163009990566,"plays":2769},"101892073899926":{"plays":86,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.244483299997,"sum":0,"kfImpact":1.3108333230018617},"111888587970150":{"plays":293,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"89759742661754":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"105242552416030":{"last":0.6655258999962825,"sumD":296.0688621997833,"sumI":16.454748900010146,"sumDI":110.50776337053462,"plays":6057,"kfImpact":0.8666666924953461,"deaths":0,"avg":0.4447229432435174,"conf":37,"max":0.8893094000013662,"samples":37,"distAvg":8.001861140534685,"intercept":0.5557258541470741,"min":0,"cancels":0,"sum":16.454748900010146,"misses":0,"ema":0.37008046733379937,"kfTimestamp":10716.498678900003,"slope":-0.013872136613475323,"sumDD":3894.5232062746829},"115880291306156":{"last":0.5481660999998894,"combo":{"18998838518":{"samples":2,"sum":0.13111150000077033,"avg":0.06555575000038516},"113631162072406":{"samples":1,"sum":0.12942049999946904,"avg":0.12942049999946904}},"cancelRate":0.5,"sumD":38.17212247848511,"sumI":3.83705129999953,"sumDI":20.909485758203986,"misses":2,"kfImpact":1.4625000000000002,"deaths":0,"avg":0.5503917000000456,"conf":10,"max":0.5682888999999705,"samples":10,"distAvg":3.8172122478485108,"intercept":0.01875120898090974,"min":0.5307111000001896,"sum":5.503917000000456,"cancels":7,"sumDD":211.21484529622809,"slope":0.09560744787632432,"kfTimestamp":10715.6490299,"ema":0.5577846581675644,"plays":700},"123699046765506":{"last":0.6008235000044806,"sumD":1024.2721462249756,"sumI":86.26545860000079,"sumDI":2273.3679078560269,"plays":962,"deaths":3,"conf":49,"max":2.940976199999568,"samples":40,"distAvg":25.60680365562439,"intercept":-0.35499665829378415,"min":0,"sumDD":26884.761379727508,"cancels":0,"ema":0.8025672468245981,"misses":0,"avg":2.1566364650000198,"sum":86.26545860000079,"slope":0.09808460115021571},"13839637848":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.890994599999,"sum":0,"kfImpact":3.25},"17891447960":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.257582699996,"sum":0,"kfImpact":0.541666653752327},"139018901346649":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.116023399998,"sum":0,"kfImpact":0.9750000000000001},"14097316812":{"plays":184,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"115140436410496":{"last":0.530765400006203,"sumD":38.5125093460083,"sumI":1.1734992000056082,"sumDI":23.17527902071632,"plays":265,"deaths":0,"conf":2,"max":0.6427337999994052,"samples":2,"distAvg":19.25625467300415,"min":0,"sum":1.1734992000056082,"avg":0.5867496000028041,"misses":0,"cancels":0,"ema":0.6091432800014445,"sumDD":794.9173762345972},"9734474426":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.152622100002,"sum":0,"kfImpact":2.459166646003723},"73284236042657":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"120108509419137":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.0313398,"sum":0,"kfImpact":1.0400000154972078},"135471287664129":{"plays":14,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"117336070654145":{"last":0.5134186999930535,"sumD":26.96260643005371,"sumI":0.9447751999978209,"sumDI":12.511701271972168,"plays":191,"deaths":0,"conf":2,"max":0.5134186999930535,"samples":2,"distAvg":13.481303215026856,"min":0,"sum":0.9447751999978209,"avg":0.47238759999891047,"misses":0,"cancels":0,"ema":0.4559751600012532,"sumDD":378.53957917346636},"80432589993088":{"plays":32,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9405518210":{"plays":31,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.315405299996,"sum":0,"kfImpact":3.9000000000000005},"128875759494501":{"last":0.7057894999888958,"combo":{"18429789282":{"samples":3,"sum":1.0117833000022075,"avg":0.3372611000007358},"16417788544":{"samples":1,"sum":0.607562199998938,"avg":0.607562199998938},"18998838518":{"samples":8,"sum":1.149024800004554,"avg":0.14362810000056926},"134944919039812":{"samples":1,"sum":0.12231880000035744,"avg":0.12231880000035744},"130216339682903":{"samples":2,"sum":1.627542899997934,"avg":0.813771449998967}},"cancelRate":0.08695652173913043,"sumD":830.3432838916779,"sumI":36.70872819999022,"sumDI":647.5055271878863,"ema":0.7478508165747042,"kfImpact":2.0149999380111698,"distAvg":14.567426033187332,"min":0.7057894999888958,"conf":57,"max":1.1477952000059304,"samples":57,"slope":0.02123945433482767,"intercept":0.3346085954305628,"misses":12,"sum":44.28328149999106,"cancels":6,"sumDD":17404.6621637321,"avg":0.7768996754384397,"kfTimestamp":10719.341922499996,"successes":4,"plays":504},"119744649456014":{"last":0.5159639000048628,"lastLearned":3010.425046799999,"combo":{"18998838518":{"samples":10,"sum":1.2189698999973189,"avg":0.12189698999973189},"128875759494501":{"samples":1,"sum":0.0631372999996529,"avg":0.0631372999996529},"134944919039812":{"samples":6,"sum":0.78023210000174,"avg":0.13003868333362335}},"cancelRate":0.020833333333333333,"sumD":74.31561875343323,"sumI":2.793424200002846,"calEma":0.2740296000010858,"successes":10,"kfImpact":1.516666615009308,"ema":0.389676482878229,"min":0.09731309999915539,"sumDI":19.158567580794068,"calSum":0.2740296000010858,"plays":1677,"deaths":0,"cancels":1,"conf":11,"max":0.5290270000004966,"sumDD":1305.9852540387824,"calAvg":0.2740296000010858,"intercept":0.25154170726418975,"misses":6,"sum":4.8606502000020559,"avg":0.4418772909092778,"distAvg":6.755965341221202,"samples":11,"kfTimestamp":10715.374458500002,"slope":0.00035612191004648586,"calSamples":1},"17164097298":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.190905099997,"sum":0,"kfImpact":0.5200000077486039},"73140327970997":{"plays":242,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18697609875":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14411112489":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.676867499998,"sum":0,"kfImpact":1.2349999845027924},"6748003806":{"last":0.44724139999743786,"sumD":21.554059982299806,"sumI":0.8462533999991138,"sumDI":9.024116671489744,"plays":9230,"deaths":0,"conf":2,"max":0.44724139999743786,"samples":2,"distAvg":10.777029991149903,"sumDD":240.20979168918348,"min":0,"kfImpact":3.9000000000000005,"avg":0.4231266999995569,"ema":0.4134808200004045,"misses":0,"kfTimestamp":10715.322626499998,"cancels":0,"sum":0.8462533999991138},"9387519869":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18432238211":{"plays":304,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"76491120300796":{"plays":122,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5283242,"sum":0,"kfImpact":0.920833307504654},"137805914141039":{"last":1.1268892999796663,"sumD":84.0423755645752,"sumI":5.830529299913906,"sumDI":45.527166916751088,"plays":2455,"deaths":0,"conf":9,"max":1.375250999990385,"samples":9,"distAvg":9.338041729397244,"intercept":0.807514969054334,"misses":0,"slope":-0.017099771536929949,"avg":0.6478365888793228,"sumDD":1306.3513356471509,"ema":0.8202197288256863,"min":0,"sum":5.830529299913906,"cancels":0},"14511223428":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"121924577484731":{"plays":22,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.427380300003,"sum":0,"kfImpact":2.383333384990692},"138554043667476":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.665350199997,"sum":0,"kfImpact":1.0400000154972078},"140067530156353":{"last":0.16081149999808987,"sumD":21.518864631652833,"sumI":0.45537890000559858,"sumDI":3.295336211197194,"plays":860,"deaths":0,"conf":3,"max":0.20475060000899249,"samples":3,"distAvg":7.17295487721761,"intercept":0.12153747642831033,"min":0,"sum":0.45537890000559858,"avg":0.15179296666853285,"misses":0,"cancels":0,"ema":0.13525130800058833,"sumDD":161.21110944531075,"slope":0.004217995339175844},"11113399244":{"plays":868,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14088984049":{"plays":2479,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"114244611123839":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"103245462113802":{"plays":264,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"120228048908013":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"16924710718":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.031725699999,"sum":0,"kfImpact":2.275},"85805987092284":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.627582300003,"sum":0,"kfImpact":1.765833353996277},"13835138543":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"107848116205888":{"last":1.3728753000032157,"sumD":10.709036111831665,"sumI":2.7400672000039778,"sumDI":14.693259804512263,"plays":54,"deaths":0,"conf":2,"max":1.3728753000032157,"samples":2,"distAvg":5.3545180559158329,"sumDD":86.01772734850607,"min":0,"kfImpact":1.354166615009308,"cancels":0,"ema":1.368896920001498,"misses":0,"kfTimestamp":10713.964616500001,"sum":2.7400672000039778,"avg":1.3700336000019889},"14040644420":{"plays":4106,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10517689631":{"last":2.8351390000025278,"sumD":24.669655084609987,"sumI":16.539590700009286,"sumDI":58.289428258550298,"plays":188,"deaths":0,"conf":7,"max":2.8351390000025278,"samples":7,"distAvg":3.5242364406585695,"intercept":2.3627986714298978,"min":0,"sum":16.539590700009286,"cancels":0,"avg":2.3627986714298978,"misses":0,"ema":2.510181429937139,"sumDD":86.94169742766047,"slope":0},"14326970837":{"last":0.20193380000273465,"sumD":40.80436038970947,"sumI":0.81673010000668,"sumDI":6.005676125092362,"plays":689,"deaths":1,"conf":9,"max":0.20193380000273465,"samples":6,"distAvg":6.800726731618245,"intercept":0.08610512504311474,"min":0,"cancels":0,"sum":0.81673010000668,"avg":0.13612168333444667,"misses":0,"ema":0.15084669093534909,"sumDD":338.86477665985196,"slope":0.0073545902173649609},"75995869780371":{"plays":317,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.159219499998,"sum":0,"kfImpact":0.8125},"110620209403887":{"last":1.2884211000055075,"sumD":451.9850654602051,"sumI":24.731368699940505,"sumDI":271.32739245391448,"samples":43,"kfImpact":0.8016666769981384,"deaths":0,"distAvg":10.511280592097793,"conf":43,"max":1.2884211000055075,"sumDD":6064.926557550529,"slope":0.008652335545851325,"intercept":0.48420098260151708,"min":0,"cancels":0,"avg":0.575148109300942,"ema":0.9091004145195167,"misses":0,"kfTimestamp":10718.162428199998,"sum":24.731368699940505,"plays":133},"15507658863":{"plays":32,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"95990465493386":{"last":0.6144417000032263,"sumD":177.47222900390626,"sumI":3.698439999992843,"sumDI":65.63703906359368,"kfImpact":0.8775000154972077,"plays":31,"deaths":0,"avg":0.3698439999992843,"conf":10,"max":0.6144417000032263,"sumDD":3149.6392067614945,"slope":0,"intercept":0.3698439999992843,"min":0,"cancels":0,"sum":3.698439999992843,"misses":0,"ema":0.4942366533753624,"kfTimestamp":10717.087112300003,"distAvg":17.747222900390626,"samples":10},"18267508423":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"118925530415750":{"last":0.5207413000025554,"lastLearned":8846.491510500002,"sumD":125.48738241195679,"sumI":8.482352199999696,"successes":8,"sumDI":62.49392167277715,"samples":30,"plays":1408,"deaths":0,"min":0.31393279999974768,"conf":30,"max":0.5843154000031063,"sumDD":982.8576407559347,"distAvg":4.1829127470652269,"intercept":0.03601126495044946,"misses":25,"sum":14.976192899995113,"cancels":0,"ema":0.5161796250283571,"avg":0.49920642999983708,"kfTimestamp":10715.981106400002,"slope":0.05898612361828122,"kfImpact":0.8666666924953461},"14097106623":{"plays":431,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"139926815993252":{"last":0.8574506000004476,"sumD":7.801314353942871,"sumI":0.8574506000004476,"sumDI":6.689241673580419,"plays":32,"deaths":0,"conf":1,"max":0.8574506000004476,"samples":1,"distAvg":7.801314353942871,"sum":0.8574506000004476,"min":0,"avg":0.8574506000004476,"cancels":0,"ema":0.8574506000004476,"misses":0,"kfTimestamp":10718.9349163,"kfImpact":1.863333261013031,"sumDD":60.860505649035079},"73529457986066":{"last":0.4198249999972177,"lastLearned":3019.7197194,"combo":{"16417788544":{"samples":6,"sum":2.31597679999868,"avg":0.3859961333331133},"16417798771":{"samples":2,"sum":0.6539529000019684,"avg":0.3269764500009842},"18998838518":{"samples":28,"sum":5.140697500000897,"avg":0.1835963392857463},"13959318029":{"samples":2,"sum":0.4220715999999811,"avg":0.21103579999999057},"101162579246421":{"samples":2,"sum":0.21640779999870575,"avg":0.10820389999935287},"123458031797396":{"samples":3,"sum":0.7987585999999283,"avg":0.2662528666666428},"119744649456014":{"samples":1,"sum":0.14917920000152663,"avg":0.14917920000152663},"17096542398":{"samples":1,"sum":0.4031940000004397,"avg":0.4031940000004397},"16417792446":{"samples":4,"sum":0.46442750000096569,"avg":0.11610687500024142},"13966232587":{"samples":1,"sum":0.44455139999990936,"avg":0.44455139999990936},"134944919039812":{"samples":34,"sum":4.799082700006693,"avg":0.14114949117666746},"14597046093":{"samples":2,"sum":0.4139718999995239,"avg":0.20698594999976195}},"cancelRate":0.10931174089068827,"sumD":363.25304329395297,"sumI":15.735553999997137,"calEma":0.31792838125033998,"successes":22,"ema":0.3285304543317391,"sumDD":3779.1473452071825,"sumDI":119.62144778124991,"calSum":1.5350394000015513,"plays":5236,"distAvg":5.421687213342581,"sum":24.002698899997996,"conf":67,"max":0.8342124999999214,"samples":67,"calAvg":0.30700788000031029,"intercept":0.13207512695494376,"misses":20,"avg":0.3582492373134029,"cancels":27,"min":0.05028440000023693,"slope":0.018957915483844059,"kfTimestamp":10716.073688199998,"kfImpact":3.25,"calSamples":5},"17063237599":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"74939063051837":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.7722403,"sum":0,"kfImpact":0.8449999690055847},"11115314566":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.609749099996,"sum":0,"kfImpact":0.758333307504654},"15556095874":{"plays":27,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14089184318":{"last":0.6311983000050532,"sumD":180.182683467865,"sumI":11.33352090002154,"sumDI":83.12696371103398,"slope":-0.01896054649181881,"kfImpact":0.8775000154972077,"deaths":0,"avg":0.49276177826180608,"conf":23,"max":0.6391791999994894,"samples":23,"distAvg":7.83402971599413,"intercept":0.6412992629102029,"min":0,"cancels":0,"sum":11.33352090002154,"ema":0.5822507709233485,"misses":0,"kfTimestamp":10715.760005600001,"sumDD":1710.0803713690814,"plays":4532},"75781859971583":{"plays":36,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"11701950951":{"plays":11,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17733850110":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"78020267794128":{"last":0.7294287999993685,"sumD":12.122762680053711,"sumI":0.7294287999993685,"sumDI":8.842692234388707,"plays":21,"deaths":0,"conf":1,"max":0.7294287999993685,"samples":1,"distAvg":12.122762680053711,"misses":0,"avg":0.7294287999993685,"cancels":0,"sum":0.7294287999993685,"min":0,"ema":0.7294287999993684,"sumDD":146.96137499690304},"117649053365828":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.143962100003,"sum":0,"kfImpact":3.4125},"107291226944821":{"last":1.1257122999959393,"sumD":1124.0506632328034,"sumI":155.33618219996425,"sumDI":690.7429995240875,"plays":1670,"deaths":0,"conf":237,"max":1.7238001999994595,"samples":237,"distAvg":4.742829802670056,"intercept":0.8822434266164293,"min":0,"slope":-0.04782303117328099,"cancels":0,"sumDD":6292.853085921285,"ema":0.8825510151385649,"misses":0,"avg":0.6554269291137732,"sum":155.33618219996425},"121072695683680":{"last":0.5893899999937275,"lastLearned":8851.743142000001,"cancelRate":0.04,"sumD":62.45888161659241,"sumI":5.438413099999707,"sumDI":33.61282033307343,"slope":0.0767198027754155,"kfImpact":0.8666666924953461,"deaths":0,"sum":14.969211699996777,"conf":29,"max":0.6686853999999585,"samples":29,"distAvg":2.1537545385031868,"intercept":0.022295862786265949,"min":0.49566779999804569,"avg":0.5161797137929923,"cancels":1,"ema":0.5794143377745916,"sumDD":419.97299931916776,"kfTimestamp":10715.9922037,"misses":30,"plays":990},"17891464945":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.243237199997,"sum":0,"kfImpact":0.6608333230018616},"109817071639480":{"plays":793,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.582507899999,"sum":0,"kfImpact":0.4983333230018616},"85733968676546":{"last":1.7324913999909768,"sumD":429.36504077911379,"sumI":73.14295679991483,"sumDI":862.7520752002668,"plays":81,"deaths":0,"conf":37,"max":2.7747269999963466,"samples":37,"distAvg":11.60446056159767,"intercept":1.825201864588212,"misses":0,"slope":0.013066941360596907,"cancels":0,"sumDD":6051.469888713298,"ema":2.1442295460441316,"min":0,"sum":73.14295679991483,"avg":1.9768366702679683},"123458031797396":{"last":0.5554967999996734,"lastLearned":9665.308968300002,"combo":{"113631162072406":{"samples":1,"sum":0.6918894999998884,"avg":0.6918894999998884},"130216339682903":{"samples":4,"sum":1.2443466000004265,"avg":0.3110866500001066},"18998838518":{"samples":9,"sum":1.5823012000000745,"avg":0.17581124444445274},"134944919039812":{"samples":2,"sum":1.1092628000005789,"avg":0.5546314000002894},"18429789282":{"samples":3,"sum":0.3499582000004011,"avg":0.11665273333346704}},"sumD":102.30906200408936,"sumI":5.557779600011827,"calEma":0.49935007499971109,"successes":1,"ema":0.5621802019172013,"sumDI":56.63746172335192,"calSum":1.5093497999987449,"kfImpact":0.65,"sumDD":1104.407320864862,"misses":23,"conf":23,"max":0.5895227000000887,"samples":23,"calAvg":0.5031165999995816,"intercept":0.02300266086321745,"min":0.547553299998981,"slope":0.04915222856756154,"sum":12.76636500002246,"avg":0.5550593478270635,"distAvg":4.448220087134319,"kfTimestamp":10718.291515700002,"plays":908,"calSamples":3},"11434459648":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"99141883243394":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"91338444719203":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.563584700001,"sum":0,"kfImpact":1.191666692495346},"17150081722":{"last":2.9268332999781707,"sumD":2106.3461043834688,"sumI":166.1435935999798,"sumDI":1947.7738310400576,"plays":13453,"deaths":5,"conf":192,"max":2.978936999992584,"samples":177,"distAvg":11.90026047674276,"intercept":0.9854426693089762,"min":0,"slope":-0.003930863427657097,"sum":166.1435935999798,"sumDD":32539.7966391289,"ema":2.0817054148922979,"cancels":0,"misses":0,"avg":0.9386643706213548},"18445392928":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.966377600002,"sum":0,"kfImpact":2.9899999380111699},"14089013549":{"last":0.09625679999953718,"sumD":8.184690475463868,"sumI":0.09625679999953718,"sumDI":0.7878321141548423,"plays":4638,"deaths":0,"conf":1,"max":0.09625679999953718,"samples":1,"distAvg":8.184690475463868,"min":0,"sum":0.09625679999953718,"avg":0.09625679999953718,"misses":0,"cancels":0,"ema":0.09625679999953718,"sumDD":66.98915817914895},"13914947205":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.809331700002,"sum":0,"kfImpact":2.1125000000000004},"13854280230":{"last":0.1583816000056686,"sumD":225.77341556549073,"sumI":2.0751730000083627,"sumDI":31.374345866633886,"slope":0.002072462142848684,"kfImpact":1.1375,"deaths":0,"cancels":0,"conf":16,"max":0.25297259999933888,"samples":16,"distAvg":14.11083847284317,"intercept":0.10045413396170246,"min":0,"avg":0.12969831250052267,"sum":2.0751730000083627,"ema":0.1408475276860466,"misses":0,"kfTimestamp":10713.8435445,"sumDD":4195.238482125446,"plays":237},"105868290415698":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"6940299191":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.904290799997,"sum":0,"kfImpact":0.4549999922513962},"17810696204":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.677238600001,"sum":0,"kfImpact":3.5100000619888309},"14629548431":{"plays":202,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"118172369009535":{"last":1.7169155000010506,"sumD":14.113018989562989,"sumI":2.4908457999990789,"sumDI":17.576677037730108,"plays":10,"deaths":0,"conf":2,"max":1.7169155000010506,"samples":2,"distAvg":7.056509494781494,"cancels":0,"min":0,"avg":1.2454228999995394,"sum":2.4908457999990789,"ema":1.0568258599989349,"misses":0,"kfTimestamp":10716.0591469,"kfImpact":1.7875,"sumDD":99.58865249988276},"14035436505":{"last":0.147232500006794,"sumD":1071.5694587230683,"sumI":24.621892400040907,"sumDI":306.14518584118567,"conf":83,"plays":23692,"deaths":2,"distAvg":13.916486476922965,"ema":0.295978898298432,"max":2.8347494000045119,"samples":77,"slope":-0.009058041981272882,"intercept":0.44582095510395217,"min":0.05909849999443395,"distMax":29.515865325927736,"cancels":0,"avg":0.31976483636416766,"sumDD":18942.607470985247,"sum":24.621892400040907,"misses":0,"distMin":3.0935256481170656},"125759237459844":{"last":0.5962457999994513,"sumD":40.97695016860962,"sumI":3.505723900074372,"sumDI":24.971042951975439,"plays":1001,"deaths":0,"conf":6,"max":1.0157843000197318,"samples":6,"distAvg":6.82949169476827,"intercept":0.42524495708159,"misses":0,"slope":0.02328758371861062,"avg":0.584287316679062,"sumDD":324.02681305919466,"ema":0.5845607038805656,"min":0,"sum":3.505723900074372,"cancels":0},"127514178756704":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.375155000002,"sum":0,"kfImpact":2.6},"19002206698":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10717.3492539,"kfImpact":0.65,"deaths":0},"9946680894":{"last":0.12938570000551409,"sumD":10.229559898376465,"sumI":0.12938570000551409,"sumDI":1.3235587681997745,"plays":26,"deaths":0,"conf":1,"max":0.12938570000551409,"samples":1,"distAvg":10.229559898376465,"min":0,"cancels":0,"sum":0.12938570000551409,"avg":0.12938570000551409,"misses":0,"ema":0.12938570000551409,"sumDD":104.64389571447191},"18958401014":{"last":0.07098650000989437,"sumD":770.7884616851807,"sumI":24.329662099989038,"sumDI":152.61689301775253,"plays":76137,"deaths":1,"conf":97,"max":2.8826680000001945,"samples":94,"distAvg":8.199877251970007,"intercept":0.33506372196616376,"min":0,"cancels":0,"sum":24.329662099989038,"avg":0.2588261925530749,"misses":0,"ema":0.1463215383903519,"sumDD":11363.001565919709,"slope":-0.009297398859814996},"119044608330966":{"plays":24,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.5035966,"sum":0,"kfImpact":1.0400000154972078},"77117321982442":{"plays":56,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"13913720963":{"plays":46,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.785345099997,"sum":0,"kfImpact":0.9750000000000001},"12340126947":{"plays":4328,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"133856736471035":{"last":2.520636100001866,"sumD":24.64543914794922,"sumI":2.520636100001866,"sumDI":62.12218361672003,"plays":492,"deaths":0,"conf":1,"max":2.520636100001866,"samples":1,"distAvg":24.64543914794922,"min":0,"sum":2.520636100001866,"avg":2.520636100001866,"misses":0,"cancels":0,"ema":2.520636100001866,"sumDD":607.3976707952679},"77594694343908":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17165710737":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.937536500001,"sum":0,"kfImpact":0.8449999690055847},"100170492443384":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.8418637,"sum":0,"kfImpact":2.5350000619888308},"73302842286252":{"plays":10,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5562068,"sum":0,"kfImpact":0.920833307504654},"9601812936":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.1420391,"sum":0,"kfImpact":0.4549999922513962},"98579181201399":{"plays":3,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17150093453":{"last":0.9547246000001906,"sumD":79.18495512008667,"sumI":9.480004500015639,"sumDI":75.32428240215103,"plays":287,"deaths":3,"conf":19,"max":0.9944009000028018,"samples":10,"distAvg":7.918495512008667,"intercept":0.9036835149868511,"min":0,"slope":0.005596635743179336,"cancels":0,"sum":9.480004500015639,"avg":0.9480004500015639,"misses":0,"ema":0.9579094640943426,"sumDD":672.9299525603199},"10526196845":{"plays":64,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17150117745":{"last":0.4535796999989543,"sumD":191.83725380897523,"sumI":13.11932679997335,"sumDI":84.56330489404923,"plays":724,"kfImpact":0.7258333384990693,"deaths":1,"avg":0.43731089333244507,"conf":33,"max":0.6034042999963276,"samples":30,"distAvg":6.394575126965841,"intercept":0.4236149704147557,"min":0,"cancels":0,"sum":13.11932679997335,"misses":0,"ema":0.46735520808457978,"kfTimestamp":10717.0955293,"slope":0.0021418034264596857,"sumDD":1539.9042958689927},"14089083853":{"plays":556,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14565078881":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"100399765010279":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.134655599999,"sum":0,"kfImpact":1.4841666460037233},"103578292653211":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.862762099998,"sum":0,"kfImpact":1.7225000619888307},"14110194908":{"plays":464,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.463092400001,"sum":0,"kfImpact":1.1808333694934846},"87577652741355":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13831954897":{"last":0.5747104999973089,"sumD":20.00001096725464,"sumI":2.265729000002466,"sumDI":11.328651328610448,"plays":156,"deaths":0,"conf":4,"max":0.5754828999997699,"samples":4,"distAvg":5.00000274181366,"intercept":0.5664322500006165,"min":0,"cancels":0,"sum":2.265729000002466,"avg":0.5664322500006165,"misses":0,"ema":0.5644407377006682,"sumDD":100.00010967261619,"slope":0},"134479234715522":{"last":0.5756871000048704,"sumD":21.106478214263917,"sumI":1.8013566000154243,"sumDI":12.491150987537685,"kfImpact":1.0400000154972078,"plays":123,"deaths":1,"avg":0.6004522000051414,"conf":6,"max":0.6540821000089636,"sumDD":156.19595418675295,"slope":-0.02366821584471661,"intercept":0.7669697607041438,"min":0,"cancels":0,"sum":1.8013566000154243,"misses":0,"ema":0.6132397130061872,"kfTimestamp":10718.727647300002,"distAvg":7.035492738087972,"samples":3},"102257424710664":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"11384103614":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"84957638409475":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.535503699997,"sum":0,"kfImpact":0.5741666615009308},"9806993460":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.794009999998,"sum":0,"kfImpact":0.8125},"11130826551":{"last":0.8959543000019039,"lastLearned":10195.9300016,"combo":{"18998838518":{"samples":1,"sum":0.09263909999936004,"avg":0.09263909999936004}},"successes":6,"calEma":0.4885952000004181,"calSum":0.4885952000004181,"plays":206,"deaths":0,"conf":3,"max":0.8959543000019039,"samples":3,"calAvg":0.4885952000004181,"kfImpact":0.9858333230018617,"misses":5,"min":0.8959543000019039,"cancels":0,"ema":0.945954300001904,"avg":0.8959543000019039,"kfTimestamp":10716.646466600003,"sum":2.6878629000057119,"calSamples":1},"132052485145774":{"last":0.9175516000032076,"sumD":16.86439323425293,"sumI":0.9175516000032076,"sumDI":15.473950995172045,"plays":67,"deaths":0,"conf":1,"max":0.9175516000032076,"samples":1,"distAvg":16.86439323425293,"min":0,"cancels":0,"sum":0.9175516000032076,"avg":0.9175516000032076,"misses":0,"ema":0.9175516000032076,"sumDD":284.407759159516},"96681964533604":{"plays":197,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10715.3533436,"kfImpact":1.625,"deaths":0},"108088498534310":{"last":0.0968795999942813,"combo":{"18998838518":{"samples":1,"sum":0.47288149999803866,"avg":0.47288149999803866}},"sumD":962.4826622009277,"sumI":70.81488459996854,"sumDI":469.13223512292526,"plays":92801,"kfImpact":3.25,"deaths":3,"sum":70.81488459996854,"conf":126,"max":2.7400064000030399,"samples":117,"distAvg":8.22634754017887,"intercept":0.8113998096295894,"min":0,"avg":0.605255423931355,"cancels":0,"ema":0.2656836194590204,"misses":0,"kfTimestamp":10715.280882400002,"slope":-0.02505904165747806,"sumDD":12443.652794903817},"11385505343":{"plays":1183,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9387517530":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"91092219857582":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.6243473,"sum":0,"kfImpact":0.9750000000000001},"100897282827156":{"plays":394,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9602051626":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10715.8428967,"kfImpact":3.9000000000000005,"deaths":0},"14242178912":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.973831900003,"sum":0,"kfImpact":1.6141666769981385},"10245081687":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.179605500001,"sum":0,"kfImpact":1.0400000154972078},"129087511219728":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.145579900003,"sum":0,"kfImpact":1.516666615009308},"12157626001":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.054670999998,"sum":0,"kfImpact":0.8449999690055847},"9406410942":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18298046440":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"10673677478":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"86790480323481":{"plays":118,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.742279600003,"sum":0,"kfImpact":1.0400000154972078},"11391911626":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.6616392,"sum":0,"kfImpact":0.7150000154972077},"119522100909389":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9601856763":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"130063843642034":{"plays":12,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.414998100001,"sum":0,"kfImpact":2.6649999380111697},"115499981363465":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"71416929825712":{"last":0.6947986999985005,"sumD":90.47107696533203,"sumI":8.50145279998651,"sumDI":38.45677952923585,"sumDD":409.2507883633516,"plays":28,"deaths":0,"slope":0,"conf":20,"max":0.6947986999985005,"samples":20,"distAvg":4.523553848266602,"intercept":0.4250726399993255,"min":0,"avg":0.4250726399993255,"sum":8.50145279998651,"ema":0.6316693484079181,"misses":0,"kfTimestamp":10717.072051199997,"cancels":0,"kfImpact":0.920833307504654},"126720588514487":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18445405797":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.973198,"sum":0,"kfImpact":2.957500123977661},"18387079229":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.462045599998,"sum":0,"kfImpact":0.9750000000000001},"91590393074196":{"plays":14,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"10393090199":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.1959125,"sum":0,"kfImpact":2.5891666769981387},"73789109808301":{"last":2.9496072999991158,"sumD":199.64265727996827,"sumI":35.79262949999975,"sumDI":376.0913507588069,"plays":467,"deaths":0,"conf":19,"max":2.9496072999991158,"samples":19,"distAvg":10.507508277893067,"intercept":1.8838226052631447,"min":0,"slope":0,"sum":35.79262949999975,"sumDD":2097.746873989835,"ema":2.6667059140030209,"misses":0,"avg":1.8838226052631447,"cancels":0},"17151449065":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"99036187968467":{"plays":5,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"104242396518430":{"plays":23,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"76447568872156":{"last":0.5383115000004182,"sumD":5.558067440986633,"sumI":1.0844141000015953,"sumDI":3.0014141447818059,"plays":343,"deaths":0,"conf":2,"max":0.546102600001177,"samples":2,"distAvg":2.7790337204933168,"cancels":0,"min":0,"avg":0.5422070500007976,"sum":1.0844141000015953,"ema":0.5437652700009494,"misses":0,"kfTimestamp":10716.512282900003,"kfImpact":1.083333307504654,"sumDD":20.35747925926877},"75249392211553":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.835639899997,"sum":0,"kfImpact":1.625},"14089285097":{"last":0.8134507999930065,"sumD":31.13719367980957,"sumI":2.811711899996226,"sumDI":19.044661387168085,"kfImpact":0.9750000000000001,"plays":831,"deaths":0,"sum":2.811711899996226,"conf":4,"max":0.892561000000569,"sumDD":285.8655040499525,"slope":-0.06536941707724373,"intercept":1.2117830250666538,"min":0,"avg":0.7029279749990565,"cancels":0,"misses":0,"ema":0.6582263270988968,"kfTimestamp":10716.633034500002,"distAvg":7.784298419952393,"samples":4},"14039986255":{"last":1.249370600002294,"sumD":53.51817274093628,"sumI":4.326037899994844,"sumDI":60.78148284885842,"plays":1326,"deaths":0,"conf":4,"max":1.249370600002294,"samples":4,"distAvg":13.37954318523407,"intercept":0.7709574475431182,"min":0,"slope":0.023210958936051294,"sum":4.326037899994844,"avg":1.081509474998711,"misses":0,"cancels":0,"ema":1.0654460171989158,"sumDD":841.035867975884},"94458573169434":{"plays":214,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10580427719":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.497108700001,"sum":0,"kfImpact":0.9750000000000001},"10514733531":{"plays":560,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9601993333":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.822342500003,"sum":0,"kfImpact":0.5091666847467423},"http://www.roblox.com/asset/?id=522635514":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"avg":0,"cancels":0,"deaths":0,"misses":0,"kfTimestamp":5776.5378814,"sum":0,"kfImpact":0.325},"138129997108363":{"plays":9,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"127153082609965":{"last":0.18395709998731037,"combo":{"13966232587":{"samples":1,"sum":0.15096499999890512,"avg":0.15096499999890512},"18998838518":{"samples":3,"sum":0.4212484999989101,"avg":0.14041616666630339},"130216339682903":{"samples":1,"sum":0.5717387000004237,"avg":0.5717387000004237},"134944919039812":{"samples":1,"sum":0.19453710000016145,"avg":0.19453710000016145},"101162579246421":{"samples":1,"sum":0.08717439999963972,"avg":0.08717439999963972}},"sumD":182.49741995334626,"sumI":4.469296799998119,"sumDI":35.699463725162129,"plays":6028,"deaths":0,"ema":0.17734827867698989,"max":0.6655982999945991,"samples":19,"distAvg":9.605127365965592,"intercept":0.27477917657838626,"min":0.0721687000041129,"slope":-0.004117907832249545,"avg":0.23522614736832207,"sumDD":3508.341528228458,"sum":4.469296799998119,"misses":0,"conf":19,"cancels":0},"91608694318547":{"last":0.7416009999869857,"sumD":51.15289092063904,"sumI":6.90225179998788,"sumDI":39.01874923017742,"slope":-0.004010333229185173,"kfImpact":0.9966666460037232,"deaths":0,"avg":0.76691686666532,"conf":9,"max":0.9032489000019268,"samples":9,"distAvg":5.683654546737671,"intercept":0.7897102153573115,"min":0,"sum":6.90225179998788,"cancels":0,"ema":0.7601731910204586,"misses":0,"kfTimestamp":10716.705287099998,"sumDD":343.41567052005856,"plays":1099},"105958233372736":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.939417200003,"sum":0,"kfImpact":0.5741666615009308},"16417798771":{"last":0.4776461000001291,"combo":{"18998838518":{"samples":3,"sum":0.4106584999990446,"avg":0.1368861666663482},"134944919039812":{"samples":4,"sum":0.7577709000015602,"avg":0.18944272500039006}},"sumD":118.1776419878006,"sumI":8.505064799983302,"calEma":0.3412289999978384,"plays":502,"distAvg":6.219875894094768,"samples":19,"sumDI":55.64814751999144,"calSum":0.3412289999978384,"kfImpact":0.595833346247673,"deaths":0,"calAvg":0.3412289999978384,"ema":0.48078380271017609,"max":0.5369551999974647,"sumDD":1016.4934292654425,"slope":0.009762894813442246,"intercept":0.38691099536609316,"min":0,"cancels":0,"avg":0.47287725263068799,"sum":8.984667799983072,"misses":1,"kfTimestamp":10716.0320527,"conf":19,"calSamples":1},"17063241334":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"86139988631532":{"plays":35,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.199424400002,"sum":0,"kfImpact":0.65},"17188382622":{"last":1.4130689999874449,"sumD":4843.746744155884,"sumI":231.8539902997204,"sumDI":2145.7278410950536,"samples":513,"kfImpact":1.191666692495346,"deaths":1,"distAvg":9.442001450596266,"conf":516,"max":1.4380759999985458,"sumDD":59115.97484947112,"slope":-0.003246159620009539,"intercept":0.4826073399418166,"min":0,"cancels":0,"avg":0.4519570961008195,"ema":0.905317497800883,"misses":0,"kfTimestamp":10717.184233799999,"sum":231.8539902997204,"plays":2803},"10105151247":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"misses":0,"sum":0,"cancels":0,"avg":0,"kfTimestamp":10714.114610800003,"kfImpact":2.047500061988831,"deaths":0},"126037393769736":{"plays":37,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.302633699997,"sum":0,"kfImpact":1.6033333539962769},"9461063984":{"last":0.15883810000377708,"combo":{"18998838518":{"samples":1,"sum":0.05221440000059374,"avg":0.05221440000059374},"80044202039051":{"samples":1,"sum":0.06618189999971946,"avg":0.06618189999971946}},"sumD":2.749861001968384,"sumI":0.15883810000377708,"sumDI":0.43678269682714079,"plays":2934,"deaths":0,"ema":0.15883810000377708,"max":0.15883810000377708,"samples":1,"distAvg":2.749861001968384,"min":0.15883810000377708,"avg":0.15883810000377708,"cancels":0,"conf":1,"misses":0,"sum":0.15883810000377708,"sumDD":7.561735530146564},"14629341894":{"last":0.44962899999518415,"sumD":22.059162139892579,"sumI":0.8148013999962132,"sumDI":9.14666795709096,"plays":828,"deaths":0,"conf":2,"max":0.44962899999518415,"samples":2,"distAvg":11.029581069946289,"min":0,"sum":0.8148013999962132,"avg":0.4074006999981066,"misses":0,"cancels":0,"ema":0.39050937999927556,"sumDD":250.45887966693409},"14511232141":{"plays":7,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18642639522":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.454728099998,"sum":0,"kfImpact":3.672500061988831},"13863173501":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.9486627,"sum":0,"kfImpact":2.9899999380111699},"17414367633":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.238492999997,"sum":0,"kfImpact":1.083333307504654},"15562373643":{"plays":94,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10526033977":{"plays":12,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14089462130":{"last":0.48912499999278227,"sumD":148.58088374137879,"sumI":1.6684358999846155,"sumDI":39.92603013198423,"plays":11230,"deaths":0,"conf":7,"max":0.48912499999278227,"samples":7,"distAvg":21.225840534482683,"intercept":0.05104632699274449,"min":0,"sumDD":3665.0822428464277,"cancels":0,"ema":0.3053475004931712,"misses":0,"avg":0.2383479857120879,"sum":1.6684358999846155,"slope":0.008824228110781308},"99864407220386":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.922014299998,"sum":0,"kfImpact":2.3725000619888307},"10158016338":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.683322700002,"sum":0,"kfImpact":1.0291666924953463},"18168283001":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.5052192,"sum":0,"kfImpact":1.3},"98693595418815":{"last":2.828974600008223,"sumD":146.01399517059327,"sumI":27.32743560001836,"sumDI":332.5024333365361,"plays":109,"deaths":0,"conf":12,"max":2.828974600008223,"samples":12,"distAvg":12.167832930882773,"intercept":3.0887232333569218,"misses":0,"slope":-0.06668705413401188,"cancels":0,"sumDD":1776.8724002115715,"ema":2.515153009290641,"min":0,"sum":27.32743560001836,"avg":2.27728630000153},"9365454070":{"plays":29,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"77848114697086":{"plays":59,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13959318029":{"plays":80,"last":0,"combo":{"18998838518":{"samples":8,"sum":1.1137852000010753,"avg":0.1392231500001344},"13959320065":{"samples":2,"sum":0.26000549999844227,"avg":0.13000274999922113}},"max":0,"samples":0,"conf":0,"min":0,"misses":0,"sum":0,"avg":0,"deaths":0,"kfTimestamp":10716.080662100001,"cancels":0,"kfImpact":0.6302291661500931},"74564651506542":{"plays":153,"last":0,"conf":0,"max":0,"samples":0,"combo":{"18998838518":{"samples":4,"sum":0.3713327000004938,"avg":0.09283317500012345},"17096542398":{"samples":1,"sum":0.12388649999957124,"avg":0.12388649999957124}},"min":0,"sum":0,"avg":0,"misses":0,"cancels":0,"kfTimestamp":10716.2729149,"kfImpact":0.8558333694934845,"deaths":0},"94383844938706":{"plays":112,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.734464200003,"sum":0,"kfImpact":1.0400000154972078},"14023217739":{"plays":56,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17164100610":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.602485700001,"sum":0,"kfImpact":0.9752708137035371},"17732076730":{"last":0.39037870000174737,"lastLearned":8851.733460100002,"cancelRate":0.2711864406779661,"sumD":323.17450499534609,"sumI":21.718606900007218,"sumDI":131.02680794978179,"plays":3495,"deaths":3,"successes":30,"ema":0.4192529525882309,"max":2.255438800002594,"samples":75,"distAvg":4.308993399937948,"intercept":0.09946069156959313,"misses":19,"cancels":48,"sum":35.63392010001007,"avg":0.475118934666801,"min":0.05136010000205715,"conf":84,"sumDD":2241.149499882803,"slope":0.04412184380848072},"10417280670":{"plays":68,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"132341402302737":{"plays":123,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"81782950825595":{"plays":3,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11361791134":{"last":0.5341776999994181,"combo":{"18998838518":{"samples":2,"sum":0.17230100000233507,"avg":0.08615050000116753}},"cancelRate":0.3333333333333333,"sumD":39.88791036605835,"sumI":1.9256706000032864,"sumDI":18.32153569035587,"kfImpact":0.5200000077486039,"deaths":0,"slope":0.020503658403639867,"conf":5,"max":0.5341776999994181,"samples":5,"distAvg":7.97758207321167,"intercept":0.22156450228452408,"min":0.35808670000187706,"sumDD":462.54139121079268,"sum":2.442408600003546,"plays":275,"ema":0.4980470634305747,"kfTimestamp":10716.387789499997,"cancels":1,"avg":0.48848172000070919},"80960587783764":{"last":0.4692806999955792,"sumD":93.6794753074646,"sumI":4.081088899994938,"sumDI":28.36825016896446,"plays":1748,"kfImpact":0.8666666924953461,"deaths":0,"avg":0.34009074166624489,"conf":12,"max":0.7790443000048981,"samples":12,"distAvg":7.806622942288716,"intercept":0.4331029478524486,"min":0,"cancels":0,"sum":4.081088899994938,"misses":0,"ema":0.29953032363759349,"kfTimestamp":10716.469228200003,"slope":-0.011914525252955897,"sumDD":1024.34687751753},"105212904787008":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.675545899998,"sum":0,"kfImpact":2.4375},"83845561115126":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.704811800002,"sum":0,"kfImpact":1.6791666150093079},"10674204465":{"plays":220,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"118984434047616":{"plays":109,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"109730066151191":{"plays":1,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13174302209":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13911983226":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"137258130511627":{"plays":55,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9807836002":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"13863168912":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.9580986,"sum":0,"kfImpact":2.9899999380111699},"130053309887427":{"plays":30,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.2312637,"sum":0,"kfImpact":1.3},"17732858484":{"last":0.3984167000016896,"sumD":8.408618927001954,"sumI":0.3984167000016896,"sumDI":3.3501342044678665,"plays":1585,"deaths":0,"conf":1,"max":0.3984167000016896,"samples":1,"distAvg":8.408618927001954,"sumDD":70.70487225953548,"min":0,"kfImpact":3.25,"cancels":0,"ema":0.39841670000168957,"misses":0,"kfTimestamp":10716.149058299998,"avg":0.3984167000016896,"sum":0.3984167000016896},"14023154858":{"plays":18,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11151716647":{"plays":511,"last":0,"conf":0,"max":0,"samples":0,"combo":{"11273001982":{"samples":1,"sum":0.09638300000005984,"avg":0.09638300000005984}},"min":0,"misses":0,"sum":0,"avg":0,"deaths":0,"kfTimestamp":10716.4301576,"cancels":0,"kfImpact":0.65},"18924584579":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.582147399997,"sum":0,"kfImpact":3.25},"83974667129266":{"plays":616,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.253049300001,"sum":0,"kfImpact":1.0400000154972078},"6946250617":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18252557061":{"plays":15,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.4353805,"sum":0,"kfImpact":1.0400000154972078},"16932406623":{"plays":240,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"124144418002296":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.947482900003,"sum":0,"kfImpact":0.5741666615009308},"128832412932473":{"plays":652,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5899174,"sum":0,"kfImpact":0.4983333230018616},"96876412485041":{"plays":25,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"74973280679545":{"last":0.05011190001096111,"lastLearned":9685.415364800001,"combo":{"18998838518":{"samples":1,"sum":0.0864703000006557,"avg":0.0864703000006557},"91233168287060":{"samples":1,"sum":0.0814767000010761,"avg":0.0814767000010761},"76754008387126":{"samples":1,"sum":0.21222099999977218,"avg":0.21222099999977218}},"cancelRate":0.25,"sumD":172.94065880775453,"sumI":10.023858999997174,"ema":0.2513779314589586,"sumDI":63.91978037918655,"samples":35,"kfImpact":0.9750000000000001,"deaths":0,"slope":0.014382026682783333,"conf":35,"max":0.4867852000024868,"sumDD":1855.1010911422469,"distAvg":4.941161680221557,"intercept":0.21533205229959774,"min":0.05011190001096111,"cancels":7,"avg":0.4202270942855518,"misses":11,"sum":14.707948299994314,"kfTimestamp":10715.294353999998,"plays":5123,"successes":5},"76452788738980":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"127273322918288":{"plays":36,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.7490864,"sum":0,"kfImpact":1.7875},"6753497925":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.698853900001,"sum":0,"kfImpact":0.9750000000000001},"10556311261":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.725726099998,"sum":0,"kfImpact":0.9750000000000001},"93259021366820":{"plays":71,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.462354800002,"sum":0,"kfImpact":0.65},"125738965664534":{"plays":12,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9365260163":{"plays":78,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"81892426176032":{"plays":517,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18687801845":{"plays":21,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"15294979898":{"plays":7,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.2780508,"sum":0,"kfImpact":0.5849999845027923},"11188072911":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"11361552631":{"last":0.4375246999989031,"combo":{"18998838518":{"samples":4,"sum":1.056507600002078,"avg":0.2641269000005195},"130216339682903":{"samples":3,"sum":0.39051780000409055,"avg":0.13017260000136353},"101464977033970":{"samples":1,"sum":0.7655612000016845,"avg":0.7655612000016845},"11361697224":{"samples":1,"sum":0.38468959999954679,"avg":0.38468959999954679}},"sumD":62.23758411407471,"sumI":4.621823899996343,"sumDI":31.85342144256929,"plays":504,"deaths":0,"distAvg":5.186465342839559,"conf":12,"max":0.5538417999996455,"samples":12,"slope":0.04699152355398425,"intercept":0.14143208334639383,"misses":1,"sumDD":490.5359204280335,"sum":6.176015499994719,"avg":0.5146679583328933,"min":0.4375246999989031,"kfTimestamp":10716.4074254,"kfImpact":0.4766666769981384,"ema":0.5004665915112113},"17300515941":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"6950979119":{"plays":110,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"94934451271455":{"last":0.1491632999968715,"sumD":920.8586082458496,"sumI":67.00884739998583,"sumDI":479.5228488056273,"plays":2482,"deaths":9,"conf":142,"max":2.571296400000392,"samples":115,"distAvg":8.007466158659561,"intercept":0.785616361180894,"min":0,"avg":0.5826856295650942,"sum":67.00884739998583,"misses":0,"cancels":0,"ema":0.4341777980469315,"sumDD":9624.816516428946,"slope":-0.0253426898840332},"15492898099":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.436510400003,"sum":0,"kfImpact":0.9641666769981384},"74275989624474":{"plays":305,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"17060594573":{"plays":18,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"99354874963450":{"plays":176,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10358495111":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"115338865375824":{"last":0.5568787000011071,"combo":{"113631162072406":{"samples":5,"sum":0.8857892999985779,"avg":0.1771578599997156},"119333842262474":{"samples":1,"sum":0.10096979999980249,"avg":0.10096979999980249},"18998838518":{"samples":10,"sum":1.7867461999994703,"avg":0.17867461999994703},"115880291306156":{"samples":2,"sum":0.2881613000008656,"avg":0.1440806500004328}},"cancelRate":0.015625,"sumD":65.87157118320465,"sumI":7.941535800000565,"sumDI":37.0538982949216,"kfImpact":1.4625000000000002,"plays":1029,"deaths":0,"conf":14,"ema":0.6024121630207582,"max":0.7756772000011551,"samples":14,"slope":-0.006172008754112013,"intercept":0.5962925509993156,"min":0,"avg":0.5672525571428976,"cancels":1,"sum":7.941535800000565,"sumDD":360.4707985487285,"kfTimestamp":10715.660389800003,"misses":2,"distAvg":4.705112227371761},"18432245367":{"plays":209,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"137122650392334":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"79193623419367":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.874841800003,"sum":0,"kfImpact":1.7875},"18998797304":{"last":1.2876320000068518,"sumD":186.66070425510407,"sumI":9.544630600023539,"sumDI":110.76290698578402,"plays":12089,"deaths":0,"conf":22,"max":1.2876320000068518,"samples":22,"distAvg":8.484577466141094,"intercept":0.11250378975520951,"min":0,"slope":0.037873784166951248,"cancels":0,"sumDD":2370.052856694361,"ema":0.931695883981644,"misses":0,"avg":0.43384684545561538,"sum":9.544630600023539},"104296721489281":{"last":0.5818658999996842,"sumD":81.07629680633545,"sumI":3.2670630000020539,"sumDI":44.58793447192086,"plays":202,"deaths":0,"conf":6,"max":0.5818658999996842,"samples":6,"distAvg":13.512716134389243,"intercept":0.5169233000750412,"min":0,"sumDD":1311.5902435833514,"cancels":0,"ema":0.5533968253591495,"misses":0,"avg":0.5445105000003423,"sum":3.2670630000020539,"slope":0.0020415732596567317},"122969699986265":{"plays":77,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.236369899998,"sum":0,"kfImpact":1.3108333230018617},"17826116646":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.909940899997,"sum":0,"kfImpact":1.0724999845027926},"17188289743":{"last":0.19267549998767209,"sumD":124.38299417495728,"sumI":3.4657203999595369,"sumDI":27.826061874629717,"plays":1209,"deaths":0,"conf":14,"max":0.6458014999952866,"samples":14,"distAvg":8.88449958392552,"intercept":0.3225127916573386,"min":0,"slope":-0.008437316453140163,"cancels":0,"sumDD":1456.5110695665047,"ema":0.17733598463343665,"misses":0,"avg":0.2475514571399669,"sum":3.4657203999595369},"17891409381":{"last":0.4868495999980951,"sumD":31.23233413696289,"sumI":1.4701196000023629,"sumDI":15.288318080662919,"sumDD":334.2921483995797,"plays":137,"deaths":0,"slope":-0.0018350275787880914,"conf":3,"max":0.5005193000033614,"samples":3,"distAvg":10.410778045654297,"intercept":0.5091439314978715,"min":0,"avg":0.4900398666674543,"sum":1.4701196000023629,"ema":0.4926869840012659,"misses":0,"kfTimestamp":10715.427275299997,"cancels":0,"kfImpact":0.541666653752327},"17300768807":{"plays":3,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.051983099998,"sum":0,"kfImpact":0.7041666924953461},"75714042762031":{"plays":7,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5767413,"sum":0,"kfImpact":0.920833307504654},"17391369614":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"15513030105":{"plays":8,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"109048876178700":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"76342871135533":{"plays":241,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"126212171075042":{"last":0.17329919999974664,"sumD":8.475948333740235,"sumI":0.17329919999974664,"sumDI":1.468875065476368,"plays":1659,"deaths":0,"conf":1,"max":0.17329919999974664,"samples":1,"distAvg":8.475948333740235,"min":0,"sum":0.17329919999974664,"avg":0.17329919999974664,"misses":0,"cancels":0,"ema":0.17329919999974664,"sumDD":71.84170015623386},"95489610864558":{"last":0.05793789999734145,"sumD":270.56064319610598,"sumI":22.908648800017546,"sumDI":246.19296300194035,"plays":2119,"deaths":0,"conf":25,"max":2.961661900000763,"samples":25,"distAvg":10.822425727844239,"intercept":0.966227421140373,"misses":0,"slope":-0.004609083988567807,"cancels":0,"sumDD":3304.3766555979457,"ema":1.1512462222222589,"min":0,"sum":22.908648800017546,"avg":0.9163459520007018},"11758552295":{"plays":78,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17060587534":{"plays":7,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"131471465669923":{"last":0.5293291000125464,"sumD":199.57780599594117,"sumI":34.922325399922559,"sumDI":161.9337026580852,"plays":864,"deaths":0,"conf":38,"max":2.441274400000111,"samples":38,"distAvg":5.252047526208978,"intercept":1.1930647265272097,"min":0,"sum":34.922325399922559,"avg":0.9190085631558568,"misses":0,"cancels":0,"ema":0.6421351191291698,"sumDD":1459.8377950118155,"slope":-0.05218082319395378},"74593914973024":{"plays":112,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"6954017051":{"plays":33,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"73181280080208":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"112908770783144":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"119579376142804":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"102383192983641":{"plays":500,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"107187714478165":{"plays":1,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"130216339682903":{"last":0.09027100000093924,"combo":{"131948862232554":{"samples":1,"sum":1.01141209999696,"avg":1.01141209999696},"70967133952711":{"samples":1,"sum":0.2007935000001453,"avg":0.2007935000001453},"18998838518":{"samples":36,"sum":8.84750680000434,"avg":0.24576407777789834},"128875759494501":{"samples":3,"sum":0.46876980000160986,"avg":0.15625660000053663},"11361697224":{"samples":4,"sum":2.7680981999983489,"avg":0.6920245499995872},"123458031797396":{"samples":2,"sum":0.2612883000019792,"avg":0.1306441500009896},"17096542398":{"samples":3,"sum":2.4200026000034997,"avg":0.8066675333344998},"11361464104":{"samples":8,"sum":2.7341387000051329,"avg":0.3417673375006416},"11151716647":{"samples":3,"sum":0.4928859999963606,"avg":0.1642953333321202},"11361552631":{"samples":8,"sum":3.4215760999995838,"avg":0.42769701249994798},"17096539206":{"samples":1,"sum":0.4712553999997908,"avg":0.4712553999997908},"14597046093":{"samples":5,"sum":1.4913095000028989,"avg":0.2982619000005798}},"cancelRate":0.07894736842105263,"sumD":504.01375102996829,"sumI":40.55550959999346,"sumDI":236.109979315335,"plays":2770,"deaths":2,"conf":100,"max":2.2756792999971369,"samples":94,"distAvg":5.361848415212428,"intercept":0.26897428627601929,"min":0.06015250000018568,"sum":42.982987099994719,"cancels":12,"slope":0.03030061512972409,"sumDD":3318.191394078988,"ema":0.21112729017399116,"avg":0.45726582021270975},"18697591655":{"plays":26,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"110060348508322":{"plays":64,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"95215940936364":{"plays":242,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17386520462":{"plays":44,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.1333819,"sum":0,"kfImpact":0.9750000000000001},"16417792446":{"last":0.2538037999984226,"lastLearned":2929.3300616999988,"combo":{"18998838518":{"samples":4,"sum":0.804992499999571,"avg":0.20124812499989276},"16417788544":{"samples":1,"sum":0.1400194999987434,"avg":0.1400194999987434},"134944919039812":{"samples":5,"sum":0.6343252999995457,"avg":0.12686505999990914},"16417798771":{"samples":1,"sum":0.5104797999993025,"avg":0.5104797999993025}},"cancelRate":0.16,"sumD":86.93505191802979,"sumI":8.710639100010667,"sumDI":42.20104987696618,"ema":0.4569539125189326,"kfImpact":0.6066666692495346,"slope":0.0739574383217372,"misses":9,"conf":24,"max":0.7350313999995706,"samples":24,"distAvg":3.6222938299179079,"intercept":0.09504772332441487,"min":0.2538037999984226,"sum":11.635096400010298,"avg":0.4847956833337624,"sumDD":458.88651480094236,"cancels":4,"kfTimestamp":10716.0241427,"successes":3,"plays":715},"134246876382474":{"plays":50,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14597012797":{"plays":6,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10713.625606599999,"sum":0,"kfImpact":0.43333334624767308},"123884589298595":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.712583699999,"sum":0,"kfImpact":2.708333230018616},"18824220938":{"last":0.15945410000858829,"sumD":70.78334331512451,"sumI":2.7028135000327895,"sumDI":26.07741499583286,"plays":18598,"deaths":0,"conf":6,"max":0.964879800012568,"samples":6,"distAvg":11.797223885854086,"intercept":0.6187287969992589,"min":0,"sum":2.7028135000327895,"cancels":0,"avg":0.45046891667213159,"misses":0,"ema":0.3896206009823401,"sumDD":1242.2836055333906,"slope":-0.014262667383034559},"18989204838":{"last":0.5309103000035975,"sumD":976.8552932739258,"sumI":115.38693140022497,"sumDI":1251.9395980840769,"plays":602,"deaths":0,"conf":97,"max":2.919011900004989,"samples":97,"distAvg":10.070673126535317,"intercept":0.37677467491216989,"min":0,"slope":0.08070774502282044,"sum":115.38693140022497,"avg":1.1895559938167522,"misses":0,"cancels":0,"ema":0.4629835704019569,"sumDD":10951.678333654829},"120780764881130":{"plays":120,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17188140730":{"last":0.47460340001271109,"sumD":17338.759441137314,"sumI":870.9507907004518,"sumDI":8259.180202942598,"plays":23696,"deaths":2,"conf":1872,"max":2.8790437999996358,"samples":1866,"distAvg":9.291939679066085,"intercept":0.4377235081376072,"min":0,"slope":0.0031235639838904387,"sum":870.9507907004518,"sumDD":214369.73824365973,"ema":0.3848287193133546,"misses":0,"avg":0.46674747625962045,"cancels":0},"138581249464604":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"119664184440710":{"last":0.0671308000019053,"sumD":108.78384780883789,"sumI":1.4973229000092943,"sumDI":16.42944358823918,"plays":10303,"deaths":0,"conf":9,"max":0.3678968000021996,"samples":9,"distAvg":12.087094200981987,"intercept":0.4171277179585425,"min":0,"sum":1.4973229000092943,"avg":0.1663692111121438,"misses":0,"cancels":0,"ema":0.15184031016587855,"sumDD":1395.3222278438098,"slope":-0.020745971089232215},"16916631443":{"plays":391,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"72352073483435":{"last":0.4958695999957854,"lastLearned":9683.9069635,"combo":{"18998838518":{"samples":9,"sum":0.9397212999992917,"avg":0.10441347777769908},"18429789282":{"samples":1,"sum":0.20286099999975705,"avg":0.20286099999975705}},"cancelRate":0.22784810126582279,"sumD":671.2568519115448,"sumI":35.558513800033328,"ema":0.3573537865829225,"sumDI":285.7196422949918,"samples":105,"plays":10336,"deaths":0,"distAvg":6.39292239915757,"conf":105,"max":0.8373112000117544,"sumDD":7368.930235164426,"slope":0.01897456321199255,"intercept":0.21734960220909139,"min":0.05689760000677779,"misses":30,"sum":46.582429600022809,"avg":0.4436421866668839,"cancels":18,"kfTimestamp":10715.308659399998,"kfImpact":1.0074999690055849,"successes":19},"10537342886":{"last":2.2886378999974115,"sumD":6.49992036819458,"sumI":4.574644000000262,"sumDI":14.867410856420415,"plays":10,"deaths":1,"conf":5,"max":2.2886378999974115,"samples":2,"distAvg":3.24996018409729,"min":0,"sum":4.574644000000262,"sumDD":21.124482396435384,"ema":2.286795640001219,"cancels":0,"misses":0,"avg":2.287322000000131},"140404988445506":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"105981968910287":{"plays":72,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"10537539935":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.811222600001,"sum":0,"kfImpact":1.549166738986969},"81155234848931":{"plays":16,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14295044446":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10715.397910300002,"sum":0,"kfImpact":2.6975000619888309},"126027419442216":{"last":1.7394195000015316,"sumD":1.9129208326339722,"sumI":1.7394195000015316,"sumDI":3.327371798242697,"plays":25,"deaths":0,"conf":1,"max":1.7394195000015316,"samples":1,"distAvg":1.9129208326339722,"misses":0,"avg":1.7394195000015316,"cancels":0,"sum":1.7394195000015316,"min":0,"ema":1.7394195000015316,"sumDD":3.6592661119250495},"83097070172817":{"last":1.4250944000086748,"sumD":120.12548732757569,"sumI":18.824899100016866,"sumDI":145.340525253006,"plays":620,"deaths":0,"conf":16,"max":1.558855400000084,"samples":16,"distAvg":7.50784295797348,"intercept":1.0622185773141284,"min":0,"sum":18.824899100016866,"cancels":0,"avg":1.176556193751054,"misses":0,"ema":1.222226018652019,"sumDD":1164.9416317361502,"slope":0.0152290900431657},"79911812747670":{"last":0.9245131999923615,"sumD":251.7720594406128,"sumI":21.05071059999318,"sumDI":203.58419192330735,"plays":513,"deaths":0,"conf":26,"max":1.4974813999997423,"samples":26,"distAvg":9.683540747715878,"intercept":0.8314954236381424,"min":0,"slope":-0.002256685733360902,"sum":21.05071059999318,"sumDD":2553.7996790228946,"ema":1.133848383345556,"misses":0,"avg":0.8096427153843531,"cancels":0},"131948862232554":{"last":0.5529474000068149,"combo":{"18998838518":{"samples":2,"sum":0.13052949999837439,"avg":0.06526474999918719}},"sumD":22.75501823425293,"sumI":0.5529474000068149,"sumDI":12.58232816973782,"plays":365,"deaths":0,"conf":1,"max":0.5529474000068149,"samples":1,"distAvg":22.75501823425293,"sum":0.5529474000068149,"min":0.5529474000068149,"avg":0.5529474000068149,"cancels":0,"misses":1,"ema":0.5529474000068149,"kfTimestamp":10715.345580300003,"kfImpact":0.920833307504654,"sumDD":517.7908548411833},"17188146433":{"last":1.642187899997225,"sumD":17561.010531663895,"sumI":856.0880304001553,"sumDI":9312.71429118129,"plays":44125,"deaths":3,"conf":1671,"max":2.9541830999951346,"samples":1662,"distAvg":10.566191655634113,"intercept":0.4646335665367032,"min":0,"slope":0.004775752663261357,"sum":856.0880304001553,"sumDD":241486.40375318653,"ema":1.3662865908269475,"misses":0,"avg":0.5150950844766278,"cancels":0},"17139510110":{"plays":43,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"9566248000":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.487751,"sum":0,"kfImpact":0.3466666847467423},"113631162072406":{"last":0.05440680000174325,"combo":{"9461059177":{"samples":1,"sum":0.12519149999934599,"avg":0.12519149999934599},"123458031797396":{"samples":1,"sum":0.0700821000009455,"avg":0.0700821000009455},"119333842262474":{"samples":2,"sum":0.36020579999967597,"avg":0.18010289999983798},"18998838518":{"samples":7,"sum":0.9145585000005667,"avg":0.13065121428579525},"115338865375824":{"samples":4,"sum":0.5716010000014649,"avg":0.1429002500003662},"17096539206":{"samples":1,"sum":0.15054980000059005,"avg":0.15054980000059005},"14597046093":{"samples":1,"sum":0.07565409999915573,"avg":0.07565409999915573}},"cancelRate":0.4121212121212121,"sumD":291.59980165958407,"sumI":21.116158699987865,"sumDI":112.10894129750196,"conf":77,"kfImpact":2.166666615009308,"deaths":3,"avg":0.4248620999997804,"ema":0.17275339792302839,"max":2.243633399999453,"samples":68,"distAvg":4.288232377346824,"intercept":0.19466614072222072,"misses":5,"sum":28.890622799985068,"cancels":68,"sumDD":2048.3159097908617,"slope":0.027019432407141006,"kfTimestamp":10715.670103999997,"min":0.053943300001265018,"plays":2492},"121903551026415":{"plays":84,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.5354248,"sum":0,"kfImpact":0.920833307504654},"14327963885":{"plays":9,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"17138943090":{"last":0.5063437999997404,"sumD":439.0015769004822,"sumI":8.275090800001636,"sumDI":122.31171080820514,"plays":6526,"deaths":0,"conf":30,"max":0.5063437999997404,"samples":30,"distAvg":14.63338589668274,"intercept":0.26724520824393646,"min":0,"slope":0.0005870925441845713,"cancels":0,"sumDD":8500.60696470084,"ema":0.42343832675785778,"misses":0,"avg":0.2758363600000545,"sum":8.275090800001636},"91168538899506":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14628756235":{"last":2.179633099993225,"sumD":12.32636547088623,"sumI":2.179633099993225,"sumDI":26.866954182957206,"plays":683,"deaths":0,"conf":1,"max":2.179633099993225,"samples":1,"distAvg":12.32636547088623,"sumDD":151.93928572185633,"min":0,"kfImpact":3.25,"avg":2.179633099993225,"ema":2.179633099993225,"misses":0,"kfTimestamp":10715.471599800003,"cancels":0,"sum":2.179633099993225},"140143377555139":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.125624,"sum":0,"kfImpact":1.4841666460037233},"10592844726":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"82358037666428":{"plays":163,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"18999277514":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.592457500003,"sum":0,"kfImpact":3.25},"12412190010":{"plays":27,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14008868242":{"last":1.46194770000875,"sumD":13.56545639038086,"sumI":1.46194770000875,"sumDI":19.831987769486298,"plays":48,"deaths":0,"conf":1,"max":1.46194770000875,"samples":1,"distAvg":13.56545639038086,"min":0,"cancels":0,"sum":1.46194770000875,"avg":1.46194770000875,"misses":0,"ema":1.46194770000875,"sumDD":184.0216070793249},"78308625712128":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"14089624360":{"plays":77,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"135554982013432":{"plays":4,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.8713373,"sum":0,"kfImpact":0.8016666769981384},"131847555673060":{"plays":5,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"14565029673":{"plays":2159,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"9379030680":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.839940700003,"sum":0,"kfImpact":0.7041666924953461},"89345246529875":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.636093399997,"sum":0,"kfImpact":1.0400000154972078},"17129388098":{"plays":11,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"18998824329":{"last":0.08702439999615308,"lastLearned":9675.085471600001,"cancelRate":0.02040816326530612,"sumD":1971.647964477539,"sumI":72.89365120001276,"sumDI":707.0047038966899,"plays":64391,"deaths":1,"sum":76.63577639998948,"conf":239,"max":1.5491212999913842,"samples":236,"distAvg":8.3544405274472,"intercept":0.22268246656756086,"min":0.050024699994537517,"avg":0.32472786610165035,"cancels":5,"misses":11,"ema":0.39933589230862706,"sumDD":25973.167291438796,"slope":0.01031654202805843,"successes":19},"132769891130121":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"79232058934213":{"plays":32,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"12412509358":{"plays":56,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"127904455471577":{"plays":56,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"76823712251494":{"plays":822,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10718.378799699996,"sum":0,"kfImpact":2.708333230018616},"100143276148155":{"plays":2,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"131452944801260":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10717.615936499998,"sum":0,"kfImpact":0.2058333307504654},"16886224900":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"95365999627014":{"plays":120,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"74701342732989":{"last":0.6222618999890983,"sumD":53.177385687828067,"sumI":5.074487099976977,"sumDI":33.64846466072054,"sumDD":616.6027168280511,"plays":84,"deaths":1,"slope":-0.00031365527508646704,"conf":11,"max":0.6894766000041273,"samples":8,"distAvg":6.647173210978508,"intercept":0.636395808439159,"min":0,"kfImpact":0.8233333230018616,"avg":0.6343108874971222,"ema":0.6448039716306852,"misses":0,"kfTimestamp":10718.2629714,"sum":5.074487099976977,"cancels":0},"7017604128":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"16363593659":{"plays":63,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"134536112580394":{"plays":27,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"11151794033":{"plays":79,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.442672700003,"sum":0,"kfImpact":0.595833346247673},"100337363686814":{"plays":208,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10719.426896500001,"sum":0,"kfImpact":0.39000001549720766},"106902069840523":{"plays":0,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10714.299906300002,"sum":0,"kfImpact":3.8133334159851075},"15545518166":{"plays":64,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"avg":0,"deaths":0,"cancels":0,"misses":0},"75729004732047":{"plays":15,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"124584954720477":{"plays":187,"last":0,"max":0,"samples":0,"min":0,"sum":0,"conf":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"85079871290821":{"plays":1,"last":0,"conf":0,"max":0,"samples":0,"min":0,"sum":0,"misses":0,"cancels":0,"deaths":0,"avg":0},"10179130615":{"plays":387,"last":0,"conf":0,"max":0,"samples":0,"min":0,"cancels":0,"avg":0,"deaths":0,"misses":0,"kfTimestamp":10716.375443099998,"sum":0,"kfImpact":0.3466666847467423},"17732749500":{"last":0.11540689999674214,"sumD":25.840922832489015,"sumI":1.2855812999914634,"sumDI":7.567996050891302,"kfImpact":1.0941666305065157,"plays":311,"deaths":0,"avg":0.42852709999715446,"conf":3,"max":0.5852271999974619,"sumDD":319.2083585063431,"slope":-0.03628024403723105,"intercept":0.7410320955004734,"min":0,"cancels":0,"sum":1.2855812999914634,"misses":0,"ema":0.44422230999720338,"kfTimestamp":10716.342872399997,"distAvg":8.613640944163004,"samples":3}}
]])
end

-- Bundled by luabundle {"luaVersion":"5.1","version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Entry point — minimal bootstrap for the VV Ultimatum build.
-- Module cache: each module loads ONCE per script run, so shared utilities
-- (Settings, Humanoids, Conns, ParryTimings…) are true singletons. A Restart
-- re-runs Main.lua with a fresh cache, so edits still hot-reload.
local _cache = {}
local function customRequire(path)
    local hit = _cache[path]
    if hit ~= nil then return hit end
    local ok, content = pcall(readfile, path .. ".lua")
    if not ok or not content then error("require failed: " .. path) end
    local fn, err = loadstring(content, "=" .. path)
    if not fn then error("loadstring failed for " .. path .. ": " .. tostring(err)) end
    local env = setmetatable({ require = customRequire }, { __index = getfenv() })
    setfenv(fn, env)
    local result = fn()
    _cache[path] = result
    return result
end
getfenv().require = customRequire

-- Tear down previous run. The bundle re-runs as a FRESH module graph, so this
-- run's Conns can't see the old run's connections — we stash the teardown in a
-- global so each run cleanly kills the PREVIOUS one. Without this, every
-- loadstring reload stacked another AutoParry/ESP loop (stacked block-release
-- timers cancelled each other → nothing parried).
local prevConns = require("Utility/Conns")
if _G.__VV_Teardown then pcall(_G.__VV_Teardown) end
prevConns.teardown()
_G.__VV_Teardown = prevConns.teardown
do
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    for _, p in ipairs({ pg, gethui and gethui() or nil }) do
        if p then
            for _, n in ipairs({ "MyMenu", "Notifications", "AnimVisualizer", "KeybindHud", "VVFovCircle", "StreakSplash" }) do
                local o = p:FindFirstChild(n); if o then o:Destroy() end
            end
        end
    end
end

local State  = require("Utility/State")
local Logger = require("Utility/Logger")

local features = {
    AutoParryData       = require("Features/AutoParryData"),
    ParryTimings        = require("Features/ParryTimings"),
    Notification        = require("Features/Notification"),
    Movement            = require("Features/Movement"),
    Visuals             = require("Features/Visuals"),
    Combat              = require("Features/Combat"),
    Debug               = require("Features/Debug"),
    ModeratorChecker    = require("Features/ModeratorChecker"),
    AnimationVisualizer = require("Features/AnimationVisualizer"),
    KeybindHud          = require("Features/KeybindHud"),
    RemoteSpy           = require("Features/RemoteSpy"),
    StreamProof         = require("Utility/StreamProof"),
    PlayerTiming        = require("Features/PlayerTiming"),
    LearnOnMiss         = require("Features/LearnOnMiss"),
}
_G.__AutoParryData = features.AutoParryData
_G.__ParryTimings  = features.ParryTimings
_G.__LearnOnMiss   = features.LearnOnMiss
_G.__Notify        = features.Notification.send
_G.__AnimViz       = features.AnimationVisualizer   -- for attack-category (M1/Critical) lookup
-- NOTE: we intentionally do NOT auto-generate timings from learned data here.
-- AutoParry only ever uses timings you explicitly saved (parrytimings.json),
-- which are loaded at require-time. "Regenerate" stays available as a button.

for name, mod in pairs(features) do
    if mod.init then mod.init(State) end
    Logger.info("[Init] " .. name)
end

local Menu   = require("Menu/Main")
local Splash = require("GUI/Splash")
do
    local parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    pcall(function() if gethui then parent = gethui() end end)
    -- Animated logo splash, THEN build the menu. If no logo image is present the
    -- splash is skipped and the menu builds immediately.
    Splash.show(parent, function()
        Menu.build(State, features)
        features.Notification.send("Loaded", "Script ready", 2, Color3.fromRGB(96, 175, 255))
    end)
end
Logger.info("Script loaded.")

end)
__bundle_register("Menu/Main", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Main menu wiring: tabs, tooltips, keybinds, persistence.
local Players  = game:GetService("Players")
local LP       = Players.LocalPlayer
local Library         = require("GUI/Library")
local TimingsManager  = require("GUI/TimingsManager")
local Uninject        = require("Utility/Uninject")
local Settings        = require("Utility/Settings")
local Keybinds        = require("Utility/Keybinds")
local Conns           = require("Utility/Conns")

local Menu = {}

-- Live remote-spy list. Renders RemoteSpy.getLog() (newest first) into a
-- scrolling panel, refreshing only when the log version changes. Rows are
-- pooled/reused so a busy game doesn't thrash instances. Click a row to copy
-- the remote's full path to your clipboard.
local function buildSpyList(holder, F)
    local RunSvc = game:GetService("RunService")

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundColor3 = Color3.fromRGB(14, 12, 20)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 120, 220)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = holder
    local cn = Instance.new("UICorner", scroll); cn.CornerRadius = UDim.new(0, 8)
    local pd = Instance.new("UIPadding", scroll)
    pd.PaddingLeft = UDim.new(0, 6); pd.PaddingRight = UDim.new(0, 6)
    pd.PaddingTop  = UDim.new(0, 6); pd.PaddingBottom = UDim.new(0, 6)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 4); layout.SortOrder = Enum.SortOrder.LayoutOrder

    local empty = Instance.new("TextLabel")
    empty.Size = UDim2.new(1, 0, 0, 42); empty.BackgroundTransparency = 1
    empty.Text = "No remotes captured yet.\nEnable Spyware above, then play."
    empty.TextColor3 = Color3.fromRGB(150, 150, 170); empty.TextSize = 12
    empty.Font = Enum.Font.Gotham; empty.TextWrapped = true; empty.LayoutOrder = 9999
    empty.Parent = scroll

    local rows = {}
    local lastVersion, lastTime = -1, 0

    local function colorFor(dir)
        return dir == "in" and Color3.fromRGB(250, 165, 80) or Color3.fromRGB(120, 220, 150)
    end

    local function makeRow(i)
        local row = {}
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(26, 21, 40)
        btn.AutoButtonColor = false; btn.Text = ""; btn.BorderSizePixel = 0; btn.Parent = scroll
        local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 6)
        local tag = Instance.new("TextLabel")
        tag.Size = UDim2.new(0, 40, 0, 16); tag.Position = UDim2.fromOffset(8, 4)
        tag.BackgroundTransparency = 1; tag.Font = Enum.Font.GothamBold; tag.TextSize = 11
        tag.TextXAlignment = Enum.TextXAlignment.Left; tag.Parent = btn
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -120, 0, 16); title.Position = UDim2.fromOffset(52, 4)
        title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 12
        title.TextColor3 = Color3.fromRGB(245, 242, 252)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd; title.Parent = btn
        local cnt = Instance.new("TextLabel")
        cnt.Size = UDim2.new(0, 56, 0, 16); cnt.Position = UDim2.new(1, -62, 0, 4)
        cnt.BackgroundTransparency = 1; cnt.Font = Enum.Font.Code; cnt.TextSize = 11
        cnt.TextColor3 = Color3.fromRGB(168, 160, 192)
        cnt.TextXAlignment = Enum.TextXAlignment.Right; cnt.Parent = btn
        local args = Instance.new("TextLabel")
        args.Size = UDim2.new(1, -16, 0, 14); args.Position = UDim2.fromOffset(8, 21)
        args.BackgroundTransparency = 1; args.Font = Enum.Font.Code; args.TextSize = 11
        args.TextColor3 = Color3.fromRGB(150, 160, 182)
        args.TextXAlignment = Enum.TextXAlignment.Left
        args.TextTruncate = Enum.TextTruncate.AtEnd; args.Parent = btn
        row.btn, row.tag, row.title, row.cnt, row.args = btn, tag, title, cnt, args
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(44, 32, 68) end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(26, 21, 40) end)
        btn.MouseButton1Click:Connect(function()
            local e = row._entry
            if not e then return end
            local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
            if cb then pcall(cb, e.path) end
            F.Notification.send("Spyware", "Copied path: " .. e.name, 2,
                Color3.fromRGB(120, 220, 150))
        end)
        rows[i] = row
        return row
    end

    local function rebuild()
        local logd = F.RemoteSpy.getLog()
        local count = #logd
        empty.Visible = (count == 0)
        for i = 1, count do
            local e = logd[count - i + 1]               -- newest first
            local row = rows[i] or makeRow(i)
            row.btn.Visible = true; row.btn.LayoutOrder = i
            row.tag.Text = (e.dir == "in" and "IN" or "OUT")
            row.tag.TextColor3 = colorFor(e.dir)
            row.title.Text = e.name .. "  (" .. e.method .. ")"
            row.cnt.Text = "x" .. e.count
            row.args.Text = (e.lastArgs ~= "" and e.lastArgs) or "(no args)"
            row._entry = e
        end
        for i = count + 1, #rows do rows[i].btn.Visible = false end
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end

    rebuild()
    Conns.add(RunSvc.Heartbeat:Connect(function()
        if os.clock() - lastTime < 0.35 then return end
        local v = F.RemoteSpy.getVersion()
        if v == lastVersion then return end
        lastTime = os.clock(); lastVersion = v
        rebuild()
    end))
end

-- Player Timing panel: lists timings/projectiles captured from watching other
-- players parry. Each row offers Replace (overwrite your saved timing), Add (new
-- timing), or — for projectiles — Add to the Hitbox Range capture list.
-- Reads F.PlayerTiming.captured and rebuilds whenever its `rev` counter bumps.
local function buildPlayerTiming(holder, F, ST)
    local RunSvc = game:GetService("RunService")
    local PT = F.PlayerTiming
    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1,0,0,26); clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    clearBtn.BorderSizePixel = 0; clearBtn.AutoButtonColor = false; clearBtn.Text = "Clear Captured"
    clearBtn.TextColor3 = Color3.fromRGB(235,235,245); clearBtn.TextSize = 12; clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = root
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
    clearBtn.MouseButton1Click:Connect(function() if PT and PT.clear then PT.clear() end end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-32); scroll.Position = UDim2.fromOffset(0,32)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
    end)
    local pdg = Instance.new("UIPadding", scroll)
    pdg.PaddingTop = UDim.new(0,6); pdg.PaddingLeft = UDim.new(0,6); pdg.PaddingRight = UDim.new(0,6)

    local AV = _G.__AnimViz
    local function nameFor(id) return (AV and AV.resolveName and AV.resolveName(id)) or id end
    local function catFor(id)  return (AV and AV.categoryOf and AV.categoryOf(id)) or "Other" end

    local rows = {}
    local function smallBtn(parent, xoff, txt, col, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(52,20); b.Position = UDim2.new(1,xoff,0.5,-10)
        b.BackgroundColor3 = col; b.BorderSizePixel = 0; b.Text = txt
        b.TextColor3 = Color3.new(1,1,1); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(fn); return b
    end
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local cap = (PT and PT.captured) or {}
        if #cap == 0 then
            local r = Instance.new("TextLabel"); r.Size = UDim2.new(1,0,0,26); r.BackgroundTransparency = 1
            r.Text = (ST and ST.PlayerTiming) and "  Block/parry a mob attack to capture its timing"
                or "  Turn on 'Capture My Timings' above"
            r.TextColor3 = Color3.fromRGB(150,150,170); r.TextSize = 12; r.Font = Enum.Font.Gotham
            r.TextXAlignment = Enum.TextXAlignment.Left; r.Parent = scroll
            rows[#rows+1] = r; return
        end
        for i, e in ipairs(cap) do
            local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,28); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
            r.BorderSizePixel = 0; r.LayoutOrder = i; r.Parent = scroll
            Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
            local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-118,1,0); lbl.Position = UDim2.fromOffset(8,0)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(235,235,245); lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
            if e.kind == "parry" then
                lbl.Size = UDim2.new(1,-174,1,0)   -- room for View + Add + Replace
                lbl.Text = string.format("%s  @ %dms%s", nameFor(e.id), e.ms,
                    e.attacker and ("  (vs "..e.attacker..")") or "")
                -- View: open this animation in the Animation Visualizer.
                smallBtn(r, -56, "View", Color3.fromRGB(70,90,170), function()
                    ST.AnimViz = true
                    if F.AnimationVisualizer and F.AnimationVisualizer.openWithId then
                        F.AnimationVisualizer.openWithId(e.id)
                    end
                end)
                local pt = _G.__ParryTimings
                local has = pt and pt.getTimes and #pt.getTimes(e.id) > 0
                if has then
                    smallBtn(r, -112, "Add", Color3.fromRGB(50,140,70), function()
                        if pt and pt.addParry then pt.addParry(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Added", nameFor(e.id).." +"..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                    smallBtn(r, -168, "Replace", Color3.fromRGB(185,120,40), function()
                        if pt and pt.set then pt.set(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Replaced", nameFor(e.id).." → "..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                else
                    smallBtn(r, -112, "Save", Color3.fromRGB(50,140,70), function()
                        if pt and pt.addParry then pt.addParry(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Saved", nameFor(e.id).." @ "..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                end
            else
                local extra = (e.label and e.label ~= "" and e.label ~= e.pname) and ("  ·  "..e.label) or ""
                lbl.Text = string.format("📦 %s%s  (deflected)", e.pname, extra)
                smallBtn(r, -56, "Add", Color3.fromRGB(50,140,70), function()
                    _G.__ProjectileNames = _G.__ProjectileNames or {}; _G.__ProjectileNames[e.pname] = true
                    Settings.set("projectile_names", _G.__ProjectileNames)
                    if _G.__Notify then _G.__Notify("Projectile Added", e.pname, 2, Color3.fromRGB(120,220,150)) end
                end)
            end
            rows[#rows+1] = r
        end
    end
    refresh()
    local lastRev = -1
    Conns.add(RunSvc.Heartbeat:Connect(function()
        local rev = (PT and PT.rev) or 0
        if rev ~= lastRev then lastRev = rev; refresh() end
    end))
end

-- Learn-on-Miss review panel: candidates measured by "Measure on Hit". Nothing is
-- auto-applied — each row is View / Add (promote into your timings) / Remove. Reads
-- F.LearnOnMiss.list() and rebuilds whenever its `rev` counter bumps.
local function buildLearnOnMiss(holder, F, ST)
    local RunSvc = game:GetService("RunService")
    local LM = F.LearnOnMiss
    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1,0,0,26); clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    clearBtn.BorderSizePixel = 0; clearBtn.AutoButtonColor = false; clearBtn.Text = "Clear All"
    clearBtn.TextColor3 = Color3.fromRGB(235,235,245); clearBtn.TextSize = 12; clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = root
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
    clearBtn.MouseButton1Click:Connect(function() if LM and LM.clear then LM.clear() end end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-32); scroll.Position = UDim2.fromOffset(0,32)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
    end)
    local pdg = Instance.new("UIPadding", scroll)
    pdg.PaddingTop = UDim.new(0,6); pdg.PaddingLeft = UDim.new(0,6); pdg.PaddingRight = UDim.new(0,6)

    local AV = _G.__AnimViz
    local function nameFor(id) return (AV and AV.resolveName and AV.resolveName(id)) or id end

    local rows = {}
    local function smallBtn(parent, xoff, txt, col, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(52,20); b.Position = UDim2.new(1,xoff,0.5,-10)
        b.BackgroundColor3 = col; b.BorderSizePixel = 0; b.Text = txt
        b.TextColor3 = Color3.new(1,1,1); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(fn); return b
    end
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local cap = (LM and LM.list and LM.list()) or {}
        if #cap == 0 then
            local r = Instance.new("TextLabel"); r.Size = UDim2.new(1,0,0,26); r.BackgroundTransparency = 1
            r.Text = (ST and ST.MeasureOnHit) and "  Let a move hit you to capture it here"
                or "  Turn on 'Measure on Hit' (AutoParry tab)"
            r.TextColor3 = Color3.fromRGB(150,150,170); r.TextSize = 12; r.Font = Enum.Font.Gotham
            r.TextXAlignment = Enum.TextXAlignment.Left; r.Parent = scroll
            rows[#rows+1] = r; return
        end
        for i, e in ipairs(cap) do
            local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,28); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
            r.BorderSizePixel = 0; r.LayoutOrder = i; r.Parent = scroll
            Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
            local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-174,1,0); lbl.Position = UDim2.fromOffset(8,0)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(235,235,245); lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
            if e.kind == "proj" then
                lbl.Text = string.format("📦 %s  (projectile)", e.pname)
                -- Add a projectile by name to the Hitbox Range capture list.
                smallBtn(r, -112, "Add", Color3.fromRGB(50,140,70), function()
                    _G.__ProjectileNames = _G.__ProjectileNames or {}; _G.__ProjectileNames[e.pname] = true
                    Settings.set("projectile_names", _G.__ProjectileNames)
                    if LM and LM.removeAt then LM.removeAt(i) end
                    if _G.__Notify then _G.__Notify("Projectile Added", e.pname, 2, Color3.fromRGB(120,220,150)) end
                end)
            else
                lbl.Text = string.format("%s  @ %dms%s", nameFor(e.id), math.floor((e.sec or 0)*1000),
                    e.cat and ("  ("..e.cat..")") or "")
                smallBtn(r, -56, "View", Color3.fromRGB(70,90,170), function()
                    ST.AnimViz = true
                    if F.AnimationVisualizer and F.AnimationVisualizer.openWithId then F.AnimationVisualizer.openWithId(e.id) end
                end)
                smallBtn(r, -112, "Add", Color3.fromRGB(50,140,70), function()
                    if LM and LM.promote then LM.promote(i) end
                    if _G.__Notify then _G.__Notify("Timing Added", nameFor(e.id).." @ "..math.floor((e.sec or 0)*1000).."ms", 2, Color3.fromRGB(120,220,150)) end
                end)
            end
            smallBtn(r, -168, "Remove", Color3.fromRGB(150,60,60), function()
                if LM and LM.removeAt then LM.removeAt(i) end
            end)
            rows[#rows+1] = r
        end
    end
    refresh()
    local lastRev = -1
    Conns.add(RunSvc.Heartbeat:Connect(function()
        local rev = (LM and LM.rev) or 0
        if rev ~= lastRev then lastRev = rev; refresh() end
    end))
end

-- Notes panel: a plain-English cheat sheet for every Projectiles feature, each with
-- a one-line example. Pure text (RichText), built once. Avoid < > & in the strings
-- below — they'd break RichText (use the → arrow, it's safe).
local PROJ_NOTES = {
    {"Hitbox Range Mode", "Master switch for catching RANGED attacks (ceros, fireballs, beams). On = the script reacts to the thing flying at you instead of guessing.",
        "Enemy fires a cero across the map → you react to the beam itself."},
    {"Auto-Detect Projectiles", "Catches ANY projectile by how it MOVES, even ones you never added by name.",
        "A brand-new ability flies in → still blocked, because it sees a part travelling at you."},
    {"Parry on Entry", "When a projectile reaches you, it presses BLOCK to parry it.",
        "A fireball gets close → block pops up and parries it."},
    {"Hitbox Parry Range", "How close (in studs) a projectile gets before you block. Bigger = react sooner.",
        "Set to 25 → you block when it's 25 studs away. Fast projectiles need a bigger number."},
    {"Min Spawn Distance", "Ignore projectiles that appear closer than this. Stops little effects on your own body from triggering blocks. 0 = react to everything.",
        "Normally 0. If sparks on you cause fake blocks, raise it to about 8."},
    {"Hitbox Parry Delay", "Wait a tiny bit after the projectile arrives before blocking. Use it if you block too early.",
        "You block a hair before the hit lands → add 50ms."},
    {"Dodge on Entry (+ Dodge Range/Delay)", "Same as Parry, but DASH away instead of blocking. For big beams you can't block.",
        "A giant unblockable beam incoming → you dash out of the way."},
    {"Capture Projectiles", "Teaches the script a projectile's NAME so it watches for it. Start Capture, get hit once, then Add the name.",
        "Get hit by 'SpitShot' → click Add → now it parries SpitShot every time."},
    {"Spyware (Remote Spy)", "Shows the hidden messages your game sends and receives. For figuring out how abilities work (advanced).",
        "Curious which message fires when you block? Turn it on and watch the list."},
    {"Capture My Timings", "Learns the exact moment to block each attack by watching YOU parry it successfully.",
        "You manually parry a sword combo → it saves that timing so AutoParry nails it next time."},
    {"Parry Capture Range", "Only learn a timing if the attacker was this close when you blocked. Avoids junk.",
        "Set to 22 → ignores far-away enemies when saving your block timing."},
    {"Projectile Distance", "Only capture a projectile's name once it flies within this distance. Lower = less junk.",
        "Set to 40 → grabs the projectile name when it's 40 studs out."},
    {"Captured (Replace / Add)", "The list of stuff you just captured. Add saves it as new; Replace overwrites an old timing.",
        "Captured a better timing → click Replace to update the old one."},
    {"Learn on Misses", "When a move HITS you (you failed to block), it records that move here so you can add it later. YOU choose what to keep.",
        "A new enemy combos you → its timing shows up here → click Add and you'll auto-parry it next time."},
}
local function buildProjectilesNotes(holder)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,0); scroll.BackgroundColor3 = Color3.fromRGB(14,12,20)
    scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220); scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.Parent = holder
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0,8); pad.PaddingBottom = UDim.new(0,8)
    pad.PaddingLeft = UDim.new(0,10); pad.PaddingRight = UDim.new(0,10)
    local parts = {}
    for _, n in ipairs(PROJ_NOTES) do
        parts[#parts+1] = ('<b><font color="#c84aff">%s</font></b>\n%s\n<font color="#8a86a0">Example:  %s</font>'):format(n[1], n[2], n[3])
    end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,0); lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1; lbl.RichText = true; lbl.TextWrapped = true
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextColor3 = Color3.fromRGB(225,222,235)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Text = table.concat(parts, "\n\n")
    lbl.Parent = scroll
    local function fit() scroll.CanvasSize = UDim2.new(0,0,0,lbl.AbsoluteSize.Y + 18) end
    lbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
    task.defer(fit)
end

-- Projectile Debug panel: live feed of what the projectile defender did with your
-- SAVED projectiles (DETECT / PARRY / DODGE / NO PARRY / FAILED). Reads _G.__ProjDebug.
local function buildProjDebug(holder, F, ST)
    local RunSvc = game:GetService("RunService")
    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1,0,0,24); clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    clearBtn.BorderSizePixel = 0; clearBtn.AutoButtonColor = false; clearBtn.Text = "Clear Log"
    clearBtn.TextColor3 = Color3.fromRGB(235,235,245); clearBtn.TextSize = 12; clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = root
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
    clearBtn.MouseButton1Click:Connect(function()
        local d = _G.__ProjDebug; if d then for i = #d.log, 1, -1 do d.log[i] = nil end; d.rev = d.rev + 1 end
    end)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-30); scroll.Position = UDim2.fromOffset(0,30)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,3); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)
    local pdg = Instance.new("UIPadding", scroll)
    pdg.PaddingTop = UDim.new(0,5); pdg.PaddingLeft = UDim.new(0,6); pdg.PaddingRight = UDim.new(0,6)
    local COL = { DETECT = Color3.fromRGB(95,160,240), PARRY = Color3.fromRGB(95,215,135),
        DODGE = Color3.fromRGB(120,200,235), ["NO PARRY"] = Color3.fromRGB(245,170,80),
        FAILED = Color3.fromRGB(245,95,110) }
    local rows = {}
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local d = _G.__ProjDebug; local log = (d and d.log) or {}
        if #log == 0 then
            local r = Instance.new("TextLabel"); r.Size = UDim2.new(1,0,0,24); r.BackgroundTransparency = 1
            r.Text = (ST and ST.ProjDebug) and "  Fight near a saved projectile to see events"
                or "  Turn on 'Projectile Debug' above"
            r.TextColor3 = Color3.fromRGB(150,150,170); r.TextSize = 12; r.Font = Enum.Font.Gotham
            r.TextXAlignment = Enum.TextXAlignment.Left; r.Parent = scroll
            rows[#rows+1] = r; return
        end
        for i, e in ipairs(log) do
            local r = Instance.new("TextLabel"); r.Size = UDim2.new(1,0,0,18); r.BackgroundTransparency = 1
            r.LayoutOrder = i; r.Text = string.format("[%s] %s — %s", e.kind, e.name, e.info or "")
            r.TextColor3 = COL[e.kind] or Color3.fromRGB(225,225,235); r.TextSize = 12; r.Font = Enum.Font.Code
            r.TextXAlignment = Enum.TextXAlignment.Left; r.TextTruncate = Enum.TextTruncate.AtEnd; r.Parent = scroll
            rows[#rows+1] = r
        end
    end
    refresh()
    local lastRev = -1
    Conns.add(RunSvc.Heartbeat:Connect(function()
        local d = _G.__ProjDebug; local rev = (d and d.rev) or 0
        if rev ~= lastRev then lastRev = rev; refresh() end
    end))
end

-- Capture Projectiles panel: teaches the Hitbox Range blocker new projectiles.
-- Click "Start Capture", get hit by a ranged move once, and any part that reached
-- you appears below — click "+ Add" to save it. Combat reads _G.__ProjectileNames;
-- we persist to Settings("projectile_names").
local function buildProjectileCapture(holder, F)
    local RunSvc  = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer

    local candidates = {}      -- name -> parent string
    local capturing, capConn = false, nil
    local searchQ = ""         -- filters the saved + captured lists

    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder

    local capBtn = Instance.new("TextButton")
    capBtn.Size = UDim2.new(1,0,0,30); capBtn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    capBtn.BorderSizePixel = 0; capBtn.AutoButtonColor = false
    capBtn.Text = "▶  Start Capture — then get hit by the move"
    capBtn.TextColor3 = Color3.fromRGB(235,235,245); capBtn.TextSize = 12; capBtn.Font = Enum.Font.GothamBold
    capBtn.Parent = root
    Instance.new("UICorner", capBtn).CornerRadius = UDim.new(0,6)

    -- Options strip: Auto-Add · Scan source · Clear All ---------------------
    local opt = {
        autoAdd = Settings.get("proj_autoadd", false),
        scanWS  = Settings.get("proj_scan_ws", false),
    }
    local function mkBtn(x, w)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(w,-3,0,22); b.Position = UDim2.new(x, x>0 and 3 or 0, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(34,26,52); b.BorderSizePixel = 0; b.AutoButtonColor = false
        b.TextColor3 = Color3.fromRGB(235,235,245); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = root
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
        return b
    end
    local autoBtn, scanBtn, clearBtn = mkBtn(0,0.34), mkBtn(0.34,0.33), mkBtn(0.67,0.33)
    clearBtn.Text = "Clear Captured"; clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    local function refreshOptBtns()
        autoBtn.Text = "Auto-Add: " .. (opt.autoAdd and "ON" or "OFF")
        autoBtn.BackgroundColor3 = opt.autoAdd and Color3.fromRGB(40,90,55) or Color3.fromRGB(34,26,52)
        scanBtn.Text = "Scan: " .. (opt.scanWS and "Workspace" or "Debris")
    end

    -- Add-by-name row -------------------------------------------------------
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1,-62,0,22); nameBox.Position = UDim2.fromOffset(0,60)
    nameBox.BackgroundColor3 = Color3.fromRGB(14,12,20); nameBox.BorderSizePixel = 0
    nameBox.PlaceholderText = "Add projectile by exact part name…"; nameBox.Text = ""
    nameBox.TextColor3 = Color3.fromRGB(235,235,245); nameBox.PlaceholderColor3 = Color3.fromRGB(120,120,140)
    nameBox.TextSize = 11; nameBox.Font = Enum.Font.Gotham; nameBox.ClearTextOnFocus = false
    nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.Parent = root
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,5)
    Instance.new("UIPadding", nameBox).PaddingLeft = UDim.new(0,8)
    local addNameBtn = Instance.new("TextButton")
    addNameBtn.Size = UDim2.fromOffset(56,22); addNameBtn.Position = UDim2.new(1,-56,0,60)
    addNameBtn.BackgroundColor3 = Color3.fromRGB(50,140,70); addNameBtn.BorderSizePixel = 0
    addNameBtn.Text = "+ Add"; addNameBtn.TextColor3 = Color3.fromRGB(255,255,255)
    addNameBtn.TextSize = 11; addNameBtn.Font = Enum.Font.GothamBold; addNameBtn.Parent = root
    Instance.new("UICorner", addNameBtn).CornerRadius = UDim.new(0,5)

    -- Search row -----------------------------------------------------------
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1,0,0,22); searchBox.Position = UDim2.fromOffset(0,90)
    searchBox.BackgroundColor3 = Color3.fromRGB(14,12,20); searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "🔍  Search projectiles…"; searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(235,235,245); searchBox.PlaceholderColor3 = Color3.fromRGB(120,120,140)
    searchBox.TextSize = 11; searchBox.Font = Enum.Font.Gotham; searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left; searchBox.Parent = root
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,5)
    Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0,8)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-118); scroll.Position = UDim2.fromOffset(0,118)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
    end)
    local pd = Instance.new("UIPadding", scroll)
    pd.PaddingTop = UDim.new(0,6); pd.PaddingLeft = UDim.new(0,6); pd.PaddingRight = UDim.new(0,6)

    local function inCharacter(part)
        local m = part:FindFirstAncestorWhichIsA("Model")
        while m do if m:FindFirstChildOfClass("Humanoid") then return true end; m = m:FindFirstAncestorWhichIsA("Model") end
        return false
    end
    local function nearPlayer(part)
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        return (part.Position - hrp.Position).Magnitude <= (part.Size.Magnitude * 0.5 + 18)
    end
    local function persist() Settings.set("projectile_names", _G.__ProjectileNames or {}) end
    -- Per-projectile parry delay. Stored as _G.__ProjectileNames[name] = {d=ms};
    -- a plain `true` means "no override → use the global Hitbox Parry Delay".
    local function projDelayMs(name)
        local v = _G.__ProjectileNames and _G.__ProjectileNames[name]
        return (type(v) == "table" and tonumber(v.d)) or 0
    end
    local function setProjDelayMs(name, ms)
        _G.__ProjectileNames = _G.__ProjectileNames or {}
        _G.__ProjectileNames[name] = (ms and ms > 0) and { d = ms } or true
        persist()
    end

    local function onPart(o)
        if not capturing or not o:IsA("BasePart") or inCharacter(o) then return end
        local nm, par = o.Name, (o.Parent and o.Parent.Name or "?")
        task.delay(0.25, function()
            if not capturing or not o.Parent or not nearPlayer(o) then return end
            if _G.__ProjectileNames and _G.__ProjectileNames[nm] then return end
            if opt.autoAdd then
                _G.__ProjectileNames = _G.__ProjectileNames or {}
                _G.__ProjectileNames[nm] = true; persist()
                if _G.__Notify then _G.__Notify("Projectile Auto-Added", nm, 2, Color3.fromRGB(120,220,150)) end
            else
                candidates[nm] = par
            end
        end)
    end
    local function setCapturing(on)
        capturing = on
        if capConn then capConn:Disconnect(); capConn = nil end
        if on then
            local src = (opt.scanWS and workspace) or workspace:FindFirstChild("Debris") or workspace
            capConn = src.DescendantAdded:Connect(onPart)
            capBtn.Text = "⏹  Stop Capture  (get hit now…)"; capBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
        else
            capBtn.Text = "▶  Start Capture — then get hit by the move"; capBtn.BackgroundColor3 = Color3.fromRGB(40,30,60)
        end
    end
    capBtn.MouseButton1Click:Connect(function() setCapturing(not capturing) end)
    Conns.onTeardown(function() if capConn then capConn:Disconnect() end end)

    local rows = {}
    local function row(order, text, color, btnText, btnColor, onClick)
        local r = Instance.new("Frame")
        r.Size = UDim2.new(1,0,0,26); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
        r.BorderSizePixel = 0; r.LayoutOrder = order; r.Parent = scroll
        Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-66,1,0); lbl.Position = UDim2.fromOffset(8,0); lbl.BackgroundTransparency = 1
        lbl.Text = text; lbl.TextColor3 = color; lbl.TextSize = 12; lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
        if btnText then
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(54,18); b.Position = UDim2.new(1,-60,0.5,-9)
            b.BackgroundColor3 = btnColor; b.BorderSizePixel = 0; b.Text = btnText
            b.TextColor3 = Color3.fromRGB(255,255,255); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = r
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            b.MouseButton1Click:Connect(onClick)
        end
        rows[#rows+1] = r
    end
    local function matches(name) return searchQ == "" or name:lower():find(searchQ, 1, true) ~= nil end
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local o = 0
        o = o + 1; row(o, "KNOWN PROJECTILES   (box = parry delay ms)", Color3.fromRGB(120,225,255))
        local anySaved = false
        for name in pairs(_G.__ProjectileNames or {}) do
            if matches(name) then
                anySaved = true; o = o + 1
                local capturedName = name
                local r = Instance.new("Frame")
                r.Size = UDim2.new(1,0,0,26); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
                r.BorderSizePixel = 0; r.LayoutOrder = o; r.Parent = scroll
                Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1,-128,1,0); lbl.Position = UDim2.fromOffset(8,0); lbl.BackgroundTransparency = 1
                lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(120,220,150); lbl.TextSize = 12; lbl.Font = Enum.Font.Gotham
                lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
                -- per-projectile delay box (ms): blank/0 = use the global Hitbox Parry Delay
                local box = Instance.new("TextBox")
                box.Size = UDim2.fromOffset(48,18); box.Position = UDim2.new(1,-118,0.5,-9)
                box.BackgroundColor3 = Color3.fromRGB(14,12,20); box.BorderSizePixel = 0
                box.Text = tostring(projDelayMs(capturedName)); box.PlaceholderText = "ms"
                box.TextColor3 = Color3.fromRGB(245,205,90); box.TextSize = 11; box.Font = Enum.Font.Code
                box.ClearTextOnFocus = false; box.TextXAlignment = Enum.TextXAlignment.Center; box.Parent = r
                Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
                box.FocusLost:Connect(function()
                    local ms = math.clamp(math.floor(tonumber(box.Text) or 0), 0, 1000)
                    setProjDelayMs(capturedName, ms); box.Text = tostring(ms)
                end)
                local b = Instance.new("TextButton")
                b.Size = UDim2.fromOffset(54,18); b.Position = UDim2.new(1,-60,0.5,-9)
                b.BackgroundColor3 = Color3.fromRGB(150,50,50); b.BorderSizePixel = 0; b.Text = "Remove"
                b.TextColor3 = Color3.fromRGB(255,255,255); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = r
                Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
                b.MouseButton1Click:Connect(function() _G.__ProjectileNames[capturedName] = nil; persist(); refresh() end)
                rows[#rows+1] = r
            end
        end
        if not anySaved then o = o + 1; row(o, searchQ ~= "" and "  (no matches)" or "  (none yet)", Color3.fromRGB(150,150,170)) end
        o = o + 1; row(o, "CAPTURED — CLICK + ADD", Color3.fromRGB(255,210,95))
        local anyCand = false
        for name, par in pairs(candidates) do
            if matches(name) then
                anyCand = true; o = o + 1
                row(o, name .. "   ◂ " .. par, Color3.fromRGB(235,235,245), "+ Add", Color3.fromRGB(50,140,70), function()
                    _G.__ProjectileNames = _G.__ProjectileNames or {}
                    _G.__ProjectileNames[name] = true; candidates[name] = nil; persist(); refresh()
                    if _G.__Notify then _G.__Notify("Projectile Added", name, 2, Color3.fromRGB(120,220,150)) end
                end)
            end
        end
        if not anyCand then o = o + 1; row(o, searchQ ~= "" and "  (no matches)" or (capturing and "  (waiting — get hit by the move)" or "  (start capture, then get hit)"), Color3.fromRGB(150,150,170)) end
    end

    refresh()
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQ = searchBox.Text:lower(); refresh()
    end)
    -- Wire the option controls now that refresh()/persist()/setCapturing exist.
    refreshOptBtns()
    autoBtn.MouseButton1Click:Connect(function()
        opt.autoAdd = not opt.autoAdd; Settings.set("proj_autoadd", opt.autoAdd); refreshOptBtns()
    end)
    scanBtn.MouseButton1Click:Connect(function()
        opt.scanWS = not opt.scanWS; Settings.set("proj_scan_ws", opt.scanWS); refreshOptBtns()
        if capturing then setCapturing(false); setCapturing(true) end   -- rebind to new source
    end)
    clearBtn.MouseButton1Click:Connect(function()
        -- Clear only the CAPTURED candidates, never the saved/added list.
        for k in pairs(candidates) do candidates[k] = nil end
        refresh()
        if _G.__Notify then _G.__Notify("Projectiles", "Cleared captured — saved ones kept", 2, Color3.fromRGB(240,150,90)) end
    end)
    local function addByName(nm)
        nm = (nm or ""):gsub("^%s+",""):gsub("%s+$","")
        if nm == "" then return end
        _G.__ProjectileNames = _G.__ProjectileNames or {}; _G.__ProjectileNames[nm] = true
        candidates[nm] = nil; persist(); refresh()
        if _G.__Notify then _G.__Notify("Projectile Added", nm, 2, Color3.fromRGB(120,220,150)) end
    end
    addNameBtn.MouseButton1Click:Connect(function() addByName(nameBox.Text); nameBox.Text = "" end)
    nameBox.FocusLost:Connect(function(enter) if enter then addByName(nameBox.Text); nameBox.Text = "" end end)
    local lastSig, lastT = "", 0
    Conns.add(RunSvc.Heartbeat:Connect(function()
        if os.clock() - lastT < 0.4 then return end
        lastT = os.clock()
        local parts = {}
        for k in pairs(_G.__ProjectileNames or {}) do parts[#parts+1] = "s:" .. k end
        for k in pairs(candidates) do parts[#parts+1] = "c:" .. k end
        table.sort(parts)
        local sig = table.concat(parts, "|")
        if sig ~= lastSig then lastSig = sig; refresh() end
    end))
end

function Menu.build(State, F)
    local parent = LP:WaitForChild("PlayerGui")
    pcall(function() if gethui then parent = gethui() end end)

    F.Notification.setParent(parent)
    F.AnimationVisualizer.setParent(parent)
    F.Debug.setParent(parent)
    F.Visuals.setAnimParent(parent)
    F.KeybindHud.setParent(parent)
    F.KeybindHud.setEnabled(State.KeybindHud ~= false)

    -- Restore persisted toggles into State before building UI so initial states reflect last session.
    for k, _ in pairs(State) do
        local saved = Settings.get("state__" .. k, nil)
        if saved ~= nil then State[k] = saved end
    end
    -- Re-apply persisted Spyware state now that State is restored (init ran
    -- before the restore, so the hook wasn't installed for a saved-on session).
    F.RemoteSpy.setEnabled(State.Spyware == true)
    -- Same for Hitbox Range: init ran before the restore, so a saved-ON state set the
    -- flag but never CONNECTED the projectile defender. Re-apply so it actually runs.
    if State.HitboxRangeMode then F.Combat.setHitboxRangeMode(true) end
    local function persistent(setter, key)
        return function(v) setter(v); Settings.set("state__" .. key, v) end
    end

    local W = Library.new(parent, "Streak", "VV ULTIMATUM")

    -- Hiding the menu also hides the Animation Visualizer (and re-shows it
    -- when the menu comes back, if it was open).
    local avWasOpen = false
    W:OnVisibleChanged(function(visible)
        if not visible then
            avWasOpen = State.AnimViz == true
            if avWasOpen then
                State.AnimViz = false
                F.AnimationVisualizer.toggle(false)
            end
        elseif avWasOpen then
            State.AnimViz = true
            F.AnimationVisualizer.toggle(true)
            avWasOpen = false
        end
    end)

    -- Keybinds. Each toggle can be bound to a key from Settings → Keybinds.
    local function flip(key, setter)
        return function()
            local v = not State[key]
            setter(v); Settings.set("state__" .. key, v)
            F.Notification.send("Keybind", key .. ": " .. (v and "ON" or "OFF"), 1,
                v and Color3.fromRGB(120,220,150) or Color3.fromRGB(160,160,160), "Toggle")
        end
    end
    Keybinds.register("toggle_menu",      Enum.KeyCode.PageUp, function() W:ToggleVisible() end)
    Keybinds.register("toggle_kbhud",     Enum.KeyCode.Unknown, function()
        State.KeybindHud = not State.KeybindHud
        F.KeybindHud.setEnabled(State.KeybindHud)
        Settings.set("state__KeybindHud", State.KeybindHud)
    end)
    Keybinds.register("toggle_autoparry", Enum.KeyCode.F, flip("AutoParry",    F.Combat.setAutoParry))
    Keybinds.register("toggle_fly",       Enum.KeyCode.G, flip("Fly",          F.Movement.setFly))
    Keybinds.register("toggle_noclip",    Enum.KeyCode.H, flip("Noclip",       F.Movement.setNoclip))
    Keybinds.register("toggle_esp",       Enum.KeyCode.J, flip("ESP",          F.Visuals.setESP))
    Keybinds.register("toggle_sprint",    Enum.KeyCode.K, flip("ToggleSprint", F.Movement.setSprint))
    Keybinds.register("toggle_ttb",       Enum.KeyCode.T, flip("TweenToBack", F.Movement.setTweenToBack))
    Keybinds.register("toggle_visualizer",Enum.KeyCode.V, function()
        State.AnimViz = not State.AnimViz; F.AnimationVisualizer.toggle(State.AnimViz) end)
    -- Panic Hide — instantly hide/show EVERY script GUI (menu, ESP tags, debug,
    -- notifications…). The reliable way to clear the screen before a screenshare
    -- on executors (like Volt) that can't exclude ScreenGuis from capture.
    local _guiHidden = false
    Keybinds.register("panic_hide", Enum.KeyCode.Unknown, function()
        _guiHidden = not _guiHidden
        if not _guiHidden then F.StreamProof.setAllVisible(true) end   -- show first so the toast lands
        F.Notification.send("Panic Hide", _guiHidden and "Hiding all GUIs" or "GUIs restored", 1,
            _guiHidden and Color3.fromRGB(240,150,90) or Color3.fromRGB(120,220,150))
        if _guiHidden then task.defer(function() F.StreamProof.setAllVisible(false) end) end
    end)

    --========================================
    -- COMBAT — basic AutoParry only (fires your saved timings).
    --========================================
    W:TabGroup("Combat")
    local cmb = W:Tab("Combat", "⚔️")
    -- Projectiles tab: every projectile-related feature lives here (detect/parry/
    -- dodge, capture names, spyware). Sections below call prj: from elsewhere in
    -- this function — each tab keeps its own page, so code order doesn't matter.
    local prj = W:Tab("Projectiles", "💥")
    prj:Section("Notes — what each feature does")
    prj:Wide(function(holder) buildProjectilesNotes(holder) end, 300, nil)

    cmb:Section("AutoParry")
    cmb:Toggle("AutoParry", function() return State.AutoParry end,
        persistent(F.Combat.setAutoParry, "AutoParry"),
        "Auto-blocks (M2) at the exact frame of an enemy attack, using your saved timings.")
    cmb:Toggle("Measure on Hit", function() return State.MeasureOnHit end,
        persistent(function(v) State.MeasureOnHit = v end, "MeasureOnHit"),
        "LEARN MODE — build your sheet by getting hit. Turn this on, then let enemy moves tag you (turn AutoParry off, or let unknown ones through). When a move damages you it STAGES it into the 'Learn on Misses' list (Player Timing tab): a MELEE/animated attack stages its exact impact-frame timing; a CERO/PROJECTILE stages its part name for the Hitbox Range list. Only moves you don't already have. Nothing auto-applies — you review and choose View / Add / Remove for each.")
    -- Detection Range: the single distance knob. Routes through setDetectionRange,
    -- which pins the proximity gate AND the attack-hitbox size/reach to this value.
    cmb:Slider("Detection Range", 5, 60, function() return State.DetectionRange end,
        persistent(function(v) F.Combat.setDetectionRange(v) end, "DetectionRange"), " studs",
        "The ONE distance AutoParry uses for everything: how close an enemy must be for their attack to be detected, validated and parried, AND the attack hitbox's size + forward reach. Lower it to stop parrying far-away attacks — detection range and hitbox range always scale together so they can never mismatch.", 18)
    cmb:Toggle("Auto Dodge", function() return State.AutoDodge end,
        persistent(function(v) State.AutoDodge = v end, "AutoDodge"),
        "On attacks where you saved a DODGE timing (Animation Visualizer → Save Dodge Timing), DASH instead of block — in the direction you're moving (WASD), or backward if idle. Parry timings still block. Needs AutoParry on.")
    -- Timing fine-tune (ms shown, seconds stored). + = fire later, − = earlier.
    cmb:Slider("Timing Offset", -150, 150, function() return math.floor((State.TimingOffset or 0)*1000) end,
        function(v) State.TimingOffset = v/1000; Settings.set("state__TimingOffset", State.TimingOffset) end,
        " ms",
        "Fine-tune the parry moment. + fires later, − fires earlier. Leave at 0 unless parries feel consistently early or late.", 0)
    if math.abs(State.TimingOffset or 0) > 5 then State.TimingOffset = (State.TimingOffset or 0)/1000 end
    cmb:Slider("Block Hold", 100, 800, function() return math.floor((State.BlockHold or 0.35)*1000) end,
        function(v) State.BlockHold = v/1000; Settings.set("state__BlockHold", State.BlockHold) end,
        " ms",
        "How long to keep blocking after a parry fires. Too short and the block drops before the hit lands; longer is safer vs multiple/fast attackers.", 350)
    if (State.BlockHold or 0) > 5 then State.BlockHold = (State.BlockHold or 0)/1000 end
    cmb:Toggle("High Ping Mode", function() return State.HighPing end,
        persistent(function(v) State.HighPing = v end, "HighPing"),
        "For high / jittery ping (150ms+). Presses the block a touch earlier AND holds it ~your-ping longer, so it stays UP across the uncertainty window even when latency varies shot-to-shot. Turn on if parries inconsistently miss at high ping. (Tip: also enable Repeat on Miss as a safety net.)")
    cmb:Toggle("Nearest Target Only", function() return State.ParryNearestOnly end,
        persistent(function(v) State.ParryNearestOnly = v end, "ParryNearestOnly"),
        "Only parry the closest attacking enemy.")
    cmb:Toggle("Players Only", function() return State.ParryPlayersOnly end,
        persistent(function(v) State.ParryPlayersOnly = v end, "ParryPlayersOnly"),
        "Ignore mobs/NPCs; only parry real players.")
    cmb:Toggle("Mobs Only", function() return State.ParryMobsOnly end,
        persistent(function(v) State.ParryMobsOnly = v end, "ParryMobsOnly"),
        "Ignore players and dialogue/quest NPCs; only parry enemy mobs (Hollows, etc.).")
    cmb:Toggle("Facing Me Only", function() return State.ParryFacingMe end,
        persistent(function(v) State.ParryFacingMe = v end, "ParryFacingMe"),
        "Only parry attackers whose front is pointed at you (~70° cone). Ignores enemies swinging away from you.")
    cmb:Toggle("Facing Prediction", function() return State.FacingPredict end,
        persistent(function(v) State.FacingPredict = v end, "FacingPredict"),
        "Smarter 'Facing Me Only': predicts where a TURNING attacker will be aimed when the hit lands (from how fast they're spinning), so spin attacks / turn-ins still parry. Only affects the Facing Me Only filter. (deepwoken's facing prediction.)")
    cmb:Toggle("Parry While Tabbed Out", function() return State.ParryWhenUnfocused end,
        persistent(function(v) State.ParryWhenUnfocused = v end, "ParryWhenUnfocused"),
        "Off (default): never parry while the Roblox window is unfocused.")
    cmb:Toggle("Hitbox Prediction", function() return State.HitboxPredict end,
        persistent(function(v) State.HitboxPredict = v end, "HitboxPredict"),
        "Refines parrying by direction: only parry when you're actually inside the attacker's forward ATTACK box (the box ESP draws while they swing), not just within range. Includes where they'll be at impact (velocity-predicted). The box is sized by Detection Range and never reaches past it; stacks with Players/Mobs/Nearest/Facing.")
    cmb:Toggle("Hitbox History", function() return State.HitboxHistory end,
        persistent(function(v) State.HitboxHistory = v end, "HitboxHistory"),
        "Works with Hitbox Prediction: also tests the attacker's recent PAST positions, so a fast-moving attacker or a laggy frame doesn't slip the box. (deepwoken's position interpolation.)")
    cmb:Toggle("Repeat on Miss", function() return State.RepeatOnMiss end,
        persistent(function(v) State.RepeatOnMiss = v end, "RepeatOnMiss"),
        "If a parry whiffs (you take damage), re-press block to catch the next hit in the combo.")
    cmb:Slider("Repeat Attempts", 1, 5, function() return State.RepeatOnMissMax end,
        persistent(function(v) State.RepeatOnMissMax = v end, "RepeatOnMissMax"), "",
        "How many follow-up blocks a single missed parry may trigger.", 2)
    cmb:Toggle("Repeat Until End", function() return State.RPUE end,
        persistent(function(v) State.RPUE = v end, "RPUE"),
        "deepwoken RPUE: after the first parry, keep re-blocking every interval while that attack is still playing, so drawn-out / multi-hit attacks stay blocked.")
    cmb:Slider("Repeat Interval", 50, 500, function() return State.RPUEInterval end,
        persistent(function(v) State.RPUEInterval = v end, "RPUEInterval"), " ms",
        "How often Repeat Until End re-presses block while the attack plays.", 200)
    cmb:Toggle("AP-Breaker Filter", function() return State.APBreaker end,
        persistent(function(v) State.APBreaker = v end, "APBreaker"),
        "Ignore SPOOFED animations used to bait your parry — ones playing at an abnormal speed or with near-zero weight (a 'fake' attack). It won't parry those.")
    cmb:Slider("Max Anim Speed", 2, 20, function() return State.APBreakerSpeed end,
        persistent(function(v) State.APBreakerSpeed = v end, "APBreakerSpeed"), "x",
        "With AP-Breaker Filter on: animations at or above this speed multiplier are treated as spoofed and ignored.", 6)
    cmb:Toggle("Failure Simulation", function() return State.FailSim end,
        persistent(function(v) State.FailSim = v end, "FailSim"),
        "Intentionally MISS some parries to look human instead of frame-perfect. How often = Failure Rate.")
    cmb:Slider("Failure Rate", 0, 100, function() return State.FailRate end,
        persistent(function(v) State.FailRate = v end, "FailRate"), " %",
        "Chance (%) that any given parry is intentionally skipped while Failure Simulation is on.", 10)
    cmb:Toggle("Feint Attacks", function() return State.Feint end,
        persistent(function(v) State.Feint = v end, "Feint"),
        "If AutoParry needs to block while you're mid-swing, it feints your attack first (Combat 'Feint') so the block can come out — only at the START of your swing.")
    -- Slider shows ms but we persist SECONDS (State[k] is restored verbatim, so
    -- saving ms would reload as 250s — the old MinBlockGap double-convert bug).
    cmb:Slider("Feint Window", 50, 600, function() return math.floor((State.FeintWindow or 0.25)*1000) end,
        function(v) State.FeintWindow = v/1000; Settings.set("state__FeintWindow", State.FeintWindow) end,
        " ms",
        "How early in your swing a feint is still allowed (the 'beginning' of the swing).", 250)
    -- Self-heal any value mistakenly stored in ms from an older build.
    if (State.FeintWindow or 0) > 5 then State.FeintWindow = State.FeintWindow / 1000 end

    cmb:Toggle("Auto Feint", function() return State.SmartHit end,
        persistent(function(v) State.SmartHit = v end, "SmartHit"),
        "deepwoken-style: keep swinging freely, but the instant a REAL parry window is coming it feints (cancels) your swing so you don't whiff into their block — then AutoParry blocks. Outside a window your swings go through normally. Needs AutoParry on.")
    cmb:Dropdown("Auto Feint Type", { "Passive", "Aggressive" },
        function() return State.AutoFeintType or "Passive" end,
        persistent(function(v) State.AutoFeintType = v end, "AutoFeintType"),
        "Passive: only feint when the enemy hit would land BEFORE your swing ends (lets safe swings finish). Aggressive: always feint as soon as the parry window opens.")
    cmb:Toggle("Delayed Feints", function() return State.DelayedFeints end,
        persistent(function(v) State.DelayedFeints = v end, "DelayedFeints"),
        "Hold the feint until the last possible moment instead of cancelling early — your swing stays out as long as it's safe.")
    cmb:Slider("Auto Feint Window", 50, 500, function() return math.floor((State.SmartHitWindow or 0.25)*1000) end,
        function(v) State.SmartHitWindow = v/1000; Settings.set("state__SmartHitWindow", State.SmartHitWindow) end, " ms",
        "How early before a parry your swing is cancelled (Aggressive / non-delayed). Higher = stops you sooner.", 250)
    if (State.SmartHitWindow or 0) > 5 then State.SmartHitWindow = State.SmartHitWindow / 1000 end

    --========================================
    -- PROJECTILES TAB — Hitbox Range detect/parry/dodge (attaches to prj)
    --========================================
    prj:Section("Detection & Parry")
    prj:Toggle("Hitbox Range Mode", function() return State.HitboxRangeMode end,
        persistent(F.Combat.setHitboxRangeMode, "HitboxRangeMode"),
        "Projectile detection mode — separate from AutoParry's animation timing. For RANGED attacks it reacts to the real projectile entering your range instead of the (too-early) attack animation. Runs independently (works even with AutoParry off). Lightweight: only tracks fast, un-owned parts that appear near you.")
    prj:Toggle("Auto-Detect Projectiles", function() return State.HitboxAutoDetect end,
        persistent(function(v) State.HitboxAutoDetect = v end, "HitboxAutoDetect"),
        "NAME-AGNOSTIC catch-all. Instead of only parrying projectiles whose name is in your capture list, this reacts to ANY part that BEHAVES like a projectile — it spawned, TRAVELLED toward you, and reached your Hitbox Parry Range. Catches brand-new abilities you've never captured. Tiny effect particles (sparks/blood) are ignored by size. Leave ON; turn off only if you want strict name-list-only matching.")
    prj:Toggle("Parry on Entry", function() return State.HitboxRangeParry end,
        persistent(function(v) State.HitboxRangeParry = v end, "HitboxRangeParry"),
        "When a projectile enters Hitbox Parry Range, fire a parry (block).")
    prj:Slider("Hitbox Parry Range", 5, 80, function() return State.HitboxParryRange end,
        persistent(function(v) State.HitboxParryRange = v end, "HitboxParryRange"), " studs",
        "Distance at which an incoming projectile triggers a parry. Bigger = react earlier (good for fast projectiles).", 25)
    prj:Slider("Min Spawn Distance", 0, 80, function() return State.HitboxMinDist or 0 end,
        persistent(function(v) State.HitboxMinDist = v end, "HitboxMinDist"), " studs",
        "0 = watch ALL projectiles (default; projectile parry always works). Raise it to ignore parts that appear closer than this — filters the local melee-effect particles (sparks/smoke) that spawn on you. NOTE: too high also ignores close-range real projectiles, so tune carefully (try 6–10).", 0)
    prj:Slider("Max Engage Distance", 0, 200, function() return State.HitboxMaxDist or 0 end,
        persistent(function(v) State.HitboxMaxDist = v end, "HitboxMaxDist"), " studs",
        "0 = no limit (default). Set it to IGNORE any projectile whose centre is farther than this — so far-away ceros aimed across the map never get parried. The opposite of Min Spawn Distance: Min ignores ones too CLOSE, Max ignores ones too FAR. Try ~50 if it reacts to distant beams that never reach you.", 0)
    prj:Slider("Hitbox Parry Delay", 0, 300, function() return math.floor((State.HitboxParryDelay or 0)*1000) end,
        function(v) State.HitboxParryDelay = v/1000; Settings.set("state__HitboxParryDelay", State.HitboxParryDelay) end, " ms",
        "Wait this long AFTER the projectile enters range before parrying. 0 = parry immediately on entry; raise it if you parry slightly too early.", 0)
    if (State.HitboxParryDelay or 0) > 5 then State.HitboxParryDelay = State.HitboxParryDelay / 1000 end
    prj:Toggle("Dodge on Entry", function() return State.HitboxRangeDodge end,
        persistent(function(v) State.HitboxRangeDodge = v end, "HitboxRangeDodge"),
        "When a projectile enters Hitbox Dodge Range, DASH instead of parrying. If both this and Parry on Entry apply, parry takes priority within its range.")
    prj:Slider("Hitbox Dodge Range", 5, 80, function() return State.HitboxDodgeRange end,
        persistent(function(v) State.HitboxDodgeRange = v end, "HitboxDodgeRange"), " studs",
        "Distance at which an incoming projectile triggers a dodge (DASH in your movement direction, or backward if idle).", 25)
    prj:Slider("Hitbox Dodge Delay", 0, 300, function() return math.floor((State.HitboxDodgeDelay or 0)*1000) end,
        function(v) State.HitboxDodgeDelay = v/1000; Settings.set("state__HitboxDodgeDelay", State.HitboxDodgeDelay) end, " ms",
        "Wait this long AFTER the projectile enters range before dodging. 0 = dodge immediately on entry.", 0)
    if (State.HitboxDodgeDelay or 0) > 5 then State.HitboxDodgeDelay = State.HitboxDodgeDelay / 1000 end

    prj:Section("Debug")
    prj:Toggle("Projectile Debug", function() return State.ProjDebug end,
        persistent(function(v) State.ProjDebug = v end, "ProjDebug"),
        "Live log of what the projectile defender does with your SAVED projectiles: DETECT (saw it), PARRY/DODGE (it reacted), NO PARRY (it left range without reacting), FAILED (it reacted but you still took damage). Use it to see exactly why a cero is or isn't being parried.")
    prj:Wide(function(holder) buildProjDebug(holder, F, State) end, 210, nil)

    --========================================
    -- TIMINGS — full manager
    --========================================
    local tim = W:Tab("Timings", "⏱️")
    tim:Wide(function(holder)
        TimingsManager.build(holder, {
            timings = F.ParryTimings,
            notify  = F.Notification.send,
            resolveName = F.AnimationVisualizer.resolveName,
            openVisualizer = function(id)
                State.AnimViz = true
                F.AnimationVisualizer.openWithId(id)
            end,
        })
    end, 420, nil)

    --========================================
    -- MOVEMENT — sprint / fly / noclip grouped logically.
    --========================================
    W:TabGroup("Movement")
    local mov = W:Tab("Movement", "🏃")

    mov:Section("Speed")
    mov:Toggle("Toggle Sprint", function() return State.ToggleSprint end,
        persistent(F.Movement.setSprint, "ToggleSprint"),
        "Holds LeftShift via VirtualInputManager (no WalkSpeed change).")

    mov:Section("Flight")
    mov:Toggle("Fly", function() return State.Fly end,
        persistent(F.Movement.setFly, "Fly"),
        "WASD = move, Space = up, Ctrl = down.")
    mov:Slider("Fly Speed", 10, 300, function() return State.FlySpeed end,
        persistent(function(v) State.FlySpeed = v end, "FlySpeed"), nil,
        "Higher = faster fly.")

    mov:Section("Collision")
    mov:Toggle("Noclip", function() return State.Noclip end,
        persistent(F.Movement.setNoclip, "Noclip"),
        "Disables collision on your character. Original collisions restored on toggle off.")


    --========================================
    -- VISUALS — ESP is split into core + display elements,
    -- world rendering settings live in their own section.
    --========================================
    W:TabGroup("World")
    local vis = W:Tab("Visuals", "👁️")

    vis:Section("ESP")
    vis:Toggle("ESP", function() return State.ESP end,
        persistent(F.Visuals.setESP, "ESP"),
        "Through-wall tags. Red = player, Green = NPC, Orange = mob.")
    vis:Slider("Range", 100, 3000, function() return State.ESPRange end,
        persistent(function(v) State.ESPRange = v end, "ESPRange"), " studs",
        "How far the tags follow enemies.")
    vis:Toggle("Outline", function() return State.ESPOutline end,
        persistent(F.Visuals.setESPOutline, "ESPOutline"),
        "Glowing character outline, colored by type.")
    vis:Toggle("Show Hitboxes", function() return State.ESPHitbox end,
        persistent(function(v) State.ESPHitbox = v end, "ESPHitbox"),
        "Draw an enemy's attack hitbox ONLY while they're swinging (size from Combat → Hitbox Size). Green = normal/M1, Red = critical. It's the exact box AutoParry's Hitbox Prediction tests — stand inside it and a parry fires.")

    vis:Section("ESP Box")
    vis:Toggle("2D Box", function() return State.ESPBox end,
        persistent(function(v) State.ESPBox = v end, "ESPBox"),
        "Draw a 2D screen-space box framing each target (needs a Drawing-capable executor).")
    vis:Toggle("Box Health Bar", function() return State.ESPBoxBar end,
        persistent(function(v) State.ESPBoxBar = v end, "ESPBoxBar"),
        "Show a vertical health bar on the left edge of the 2D box.")

    vis:Section("ESP Optimization")
    vis:Toggle("Limit ESP Updates", function() return State.ESPLimitUpdates end,
        persistent(function(v) State.ESPLimitUpdates = v end, "ESPLimitUpdates"),
        "Throttle how often ESP redraws (saves FPS). Off = update every frame.")
    vis:Slider("ESP Refresh Rate", 1, 144, function() return State.ESPRefreshRate end,
        persistent(function(v) State.ESPRefreshRate = v end, "ESPRefreshRate"), "/s",
        "Max ESP updates per second when 'Limit ESP Updates' is on.", 30)
    vis:Slider("Max Targets", 0, 100, function() return State.ESPMaxTargets end,
        persistent(function(v) State.ESPMaxTargets = v end, "ESPMaxTargets"), "",
        "Only render the NEAREST N targets (0 = unlimited). The biggest FPS win at long range — keep a huge Range but cap how many boxes/highlights draw at once.", 0)
    vis:Toggle("Split Updates", function() return State.ESPSplitUpdates end,
        persistent(function(v) State.ESPSplitUpdates = v end, "ESPSplitUpdates"),
        "Spread tag updates across several frames — smoother FPS with many targets.")
    vis:Slider("Split Frames", 1, 16, function() return State.ESPSplitFrames end,
        persistent(function(v) State.ESPSplitFrames = v end, "ESPSplitFrames"), " frames",
        "How many frames to spread ESP updates over (higher = lighter, less responsive).", 3)
    vis:Toggle("No Persistent ESP", function() return State.NoPersistentESP end,
        persistent(function(v) State.NoPersistentESP = v end, "NoPersistentESP"),
        "Let ESP'd character models stream out normally instead of staying loaded.")

    vis:Section("ESP Filters")
    vis:Toggle("Players", function() return State.ESPPlayers end,
        persistent(function(v) State.ESPPlayers = v end, "ESPPlayers"),
        "Show real players (red). Turn off to hide them.")
    vis:Toggle("NPCs", function() return State.ESPNPCs end,
        persistent(function(v) State.ESPNPCs = v end, "ESPNPCs"),
        "Show interactable NPCs (green). Turn off to hide them.")
    vis:Toggle("Mobs", function() return State.ESPMobs end,
        persistent(function(v) State.ESPMobs = v end, "ESPMobs"),
        "Show hostile mobs (orange). Turn off to hide them.")
    vis:Slider("Text Scale", 50, 200, function() return State.ESPTextScale end,
        persistent(function(v) State.ESPTextScale = v end, "ESPTextScale"), "%",
        "Scale all ESP text (name / role / distance / health / weapon).", 100)

    vis:Section("ESP Display")
    vis:Toggle("Show Name",     function() return State.ESPName     end,
        persistent(function(v) State.ESPName = v end, "ESPName"),
        "Display the character's name above their head.")
    vis:Slider("Name Scale", 50, 250, function() return State.ESPNameScale end,
        persistent(function(v) State.ESPNameScale = v end, "ESPNameScale"), "%",
        "Scale just the name text, on top of the overall ESP text scale.", 100)
    vis:Toggle("Show Distance", function() return State.ESPDistance end,
        persistent(function(v) State.ESPDistance = v end, "ESPDistance"),
        "Show how far the enemy is from you.")
    vis:Toggle("Show Health",   function() return State.ESPHealth   end,
        persistent(function(v) State.ESPHealth = v end, "ESPHealth"),
        "Show the vertical health bar next to the enemy.")
    vis:Toggle("Split Health",  function() return State.ESPSplitHealth end,
        persistent(function(v) State.ESPSplitHealth = v end, "ESPSplitHealth"),
        "Move the health % up into the text stack above the head. The vertical bar stays on the side.")
    vis:Toggle("Show Weapon",   function() return State.ESPWeapon end,
        persistent(function(v) State.ESPWeapon = v end, "ESPWeapon"),
        "Shows the held weapon for players and mobs (not NPCs).")

    vis:Section("Combat Stats")
    vis:Toggle("Show Reiatsu", function() return State.ESPReiatsu end,
        persistent(function(v) State.ESPReiatsu = v end, "ESPReiatsu"),
        "Show the target's Reiatsu (spirit-energy resource), read live from their Status.")
    vis:Toggle("Show Posture", function() return State.ESPPosture end,
        persistent(function(v) State.ESPPosture = v end, "ESPPosture"),
        "Show the target's Posture (guard-break meter) as a % — high = about to be guard-broken.")
    vis:Toggle("Show Stamina", function() return State.ESPStamina end,
        persistent(function(v) State.ESPStamina = v end, "ESPStamina"),
        "Show the target's Shunpo (dash) stamina.")
    vis:Toggle("Show Race / Form", function() return State.ESPRaceForm end,
        persistent(function(v) State.ESPRaceForm = v end, "ESPRaceForm"),
        "Show the target's race/form (Soul Reaper / Hollow / Quincy, Hollow type) plus a [BOSS] tag.")
    vis:Toggle("Show States", function() return State.ESPStates end,
        persistent(function(v) State.ESPStates = v end, "ESPStates"),
        "Show active combat states (Blocking · Riposte · Projectile-Deflecting) when they're on.")

    vis:Section("Graphics")
    vis:Toggle("Fullbright", function() return State.Fullbright end,
        persistent(F.Visuals.setFullbright, "Fullbright"),
        "Pumps Lighting brightness + ambient and disables shadows.")
    -- The exact deepwoken-rewrite visual-removal set, each toggleable on its own.
    -- (Settings → Performance Mode flips all four at once.)
    vis:Toggle("No Fog", function() return State.NoFog end,
        persistent(F.Visuals.setNoFog, "NoFog"),
        "Push fog out to infinity and zero every Atmosphere density.")
    vis:Toggle("No Blur", function() return State.NoBlur end,
        persistent(F.Visuals.setNoBlur, "NoBlur"),
        "Set every BlurEffect size to 0.")
    vis:Toggle("No Shadows", function() return State.NoShadows end,
        persistent(F.Visuals.setNoShadows, "NoShadows"),
        "Disable Lighting.GlobalShadows.")
    vis:Toggle("No Animated Sea", function() return State.NoAnimatedSea end,
        persistent(F.Visuals.setNoAnimatedSea, "NoAnimatedSea"),
        "Disable the SeaClient water-animation scripts (no-op if the map has none).")

    --========================================
    -- SAFETY — server awareness + diagnostics.
    --========================================
    local saf = W:Tab("Safety", "🛡️")

    saf:Section("Server Awareness")
    saf:Toggle("Moderator Checker", function() return State.ModeratorChecker end,
        persistent(F.ModeratorChecker.setEnabled, "ModeratorChecker"),
        "Toast when a known moderator/admin joins the server.")
    saf:Toggle("YouTuber Checker", function() return State.YouTuberChecker end,
        persistent(F.ModeratorChecker.setYouTuberEnabled, "YouTuberChecker"),
        "Toast when a known content creator / YouTuber joins the server.")
    saf:Button("Scan players now", function() F.ModeratorChecker.scanAll() end,
        "Re-check every current player against the moderator + YouTuber lists.")

    saf:Section("Privacy")
    saf:Toggle("Stream Proof", function() return State.StreamProof end,
        persistent(F.StreamProof.set, "StreamProof"),
        "Routes GUIs into the hidden CoreGui layer. To actually hide from OBS/Discord GAME capture on Volt, also enable Volt's own 'OBS Stream Proof Graphics' setting. (Full screen/monitor capture can never be hidden.)")

    saf:Section("Notifications")
    saf:Toggle("Show Notifications", function() return State.NotificationsEnabled end,
        persistent(function(v) State.NotificationsEnabled = v end, "NotificationsEnabled"),
        "Master switch for corner toast notifications.")
    saf:Toggle("Feature Toggle Toasts", function() return State.NotifToggles end,
        persistent(function(v) State.NotifToggles = v end, "NotifToggles"),
        "Show a toast whenever ANY feature is toggled on/off. Turn this off to silence the on/off spam while keeping other notifications.")
    saf:Toggle("Safety Alerts", function() return State.NotifSafety end,
        persistent(function(v) State.NotifSafety = v end, "NotifSafety"),
        "Show Moderator Checker alerts — when a known mod joins, or scan results.")

    saf:Section("Diagnostics")
    saf:Toggle("Debug Panel", function() return State.Debug end,
        persistent(F.Debug.setDebug, "Debug"),
        "Floating HUD with FPS / ping / state / last parry.")

    --========================================
    -- MISC — utility tools grouped together: Attach (Tween To Back), the
    -- Animation Visualizer, and the remote spy (Spyware).
    --========================================
    W:TabGroup("Misc")
    local misc = W:Tab("Misc", "🧰")

    misc:Section("Attach")
    misc:Toggle("Tween To Back", function() return State.TweenToBack end,
        persistent(F.Movement.setTweenToBack, "TweenToBack"),
        "Smoothly slide to a point BEHIND the nearest enemy and hold there, facing them. Noclips while moving. Bindable in Settings → Keybinds.")
    misc:Toggle("Sticky Attach", function() return State.TTBSticky end,
        persistent(function(v) State.TTBSticky = v end, "TTBSticky"),
        "Keep following the SAME target until it dies, instead of always snapping to whoever's nearest.")
    misc:Toggle("Ignore Players", function() return State.TTBIgnorePlayers end,
        persistent(function(v) State.TTBIgnorePlayers = v end, "TTBIgnorePlayers"),
        "Only attach to mobs/NPCs, never to real players.")
    misc:Slider("Max Range", 10, 500, function() return State.TTBRange end,
        persistent(function(v) State.TTBRange = v end, "TTBRange"), " studs",
        "Only attach to an enemy this close or nearer — enemies farther than this are ignored.", 300)
    misc:Slider("Distance", -100, 100, function() return State.TTBDistance end,
        persistent(function(v) State.TTBDistance = v end, "TTBDistance"), " studs",
        "How far behind the target to sit. Positive = behind them, negative = in front.", 5)
    misc:Slider("Height Offset", -100, 30, function() return State.TTBHeight end,
        persistent(function(v) State.TTBHeight = v end, "TTBHeight"), " studs",
        "Vertical offset from the target (e.g. float above or sink below).", 0)
    misc:Slider("Tween Speed", 50, 1000, function() return State.TTBSpeed end,
        persistent(function(v) State.TTBSpeed = v end, "TTBSpeed"), " st/s",
        "How fast you slide toward the attach point (studs per second).", 200)

    misc:Section("Animation")
    misc:Toggle("Animation Visualizer", function() return State.AnimViz end,
        F.AnimationVisualizer.toggle,
        "Open the visualizer/scrubber window. Use the Save button there to capture parry timing.")
    misc:Button("Open Timings Tab", function() W:JumpToTab("Timings") end,
        "Manage every parry timing (search / edit / categorise).")

    -- Capture Projectiles + Spyware now live on the Projectiles tab (prj).
    prj:Section("Capture Projectiles")
    prj:Wide(function(holder) buildProjectileCapture(holder, F) end, 330, nil)

    --========================================
    -- SPYWARE — remote spy. Logs what your client fires (and optionally what
    -- the server fires at you), in a live list. This is how the parry remote
    -- (Requests.Combat:FireServer("Block", true)) was found.
    --========================================
    prj:Section("Spyware (Remote Spy)")
    prj:Toggle("Spyware", function() return State.Spyware end,
        persistent(F.RemoteSpy.setEnabled, "Spyware"),
        "Master switch. Captures every RemoteEvent/RemoteFunction call so you can see what the game fires. Needs an executor with hookmetamethod.")
    prj:Toggle("Self (Outgoing)", function() return State.SpySelf end,
        persistent(F.RemoteSpy.setSelf, "SpySelf"),
        "Log remotes YOUR client sends to the server (FireServer / InvokeServer). Leave on — this is what reveals your own ability/parry remotes.")
    prj:Toggle("Enemies (Incoming)", function() return State.SpyEnemies end,
        persistent(F.RemoteSpy.setEnemies, "SpyEnemies"),
        "Also log remotes the SERVER fires at you (OnClientEvent) — often enemy actions/state. Connects to every RemoteEvent in ReplicatedStorage.")

    prj:Section("Spyware Controls")
    prj:Toggle("Pause Capture", function() return State.SpyPaused end,
        persistent(F.RemoteSpy.setPaused, "SpyPaused"),
        "Freeze the list so you can read it without new calls scrolling it. Turn off to resume capturing.")
    prj:Button("Clear Log", function() F.RemoteSpy.clear() end,
        "Wipe every captured remote from the list below.")

    prj:Section("Captured Remotes")
    prj:Wide(function(holder) buildSpyList(holder, F) end, 320, nil)

    --========================================
    -- PLAYER TIMING — learn parry timings by watching OTHER players parry.
    --========================================
    -- Player Timing now lives on the Projectiles tab (prj) too.
    prj:Section("Player Timing")
    prj:Toggle("Capture My Timings", function() return State.PlayerTiming end,
        persistent(F.PlayerTiming.setEnabled, "PlayerTiming"),
        "PARRY: when YOU block a mob's attack, capture the attacker's animation + the frame you blocked at. PROJECTILE: ANY projectile that flies at you and comes within the Projectile Distance is captured by its real name (the moving part, not effect particles). Then Replace/Add below.")
    prj:Slider("Parry Capture Range", 8, 80, function() return State.PlayerTimingRange end,
        persistent(function(v) State.PlayerTimingRange = v end, "PlayerTimingRange"), " studs",
        "For PARRY timings: only capture when the attacker is this close when you block.", 22)
    prj:Slider("Projectile Distance", 5, 150, function() return State.PlayerTimingProjDist or 40 end,
        persistent(function(v) State.PlayerTimingProjDist = v end, "PlayerTimingProjDist"), " studs",
        "For PROJECTILES: capture a projectile once it flies within this distance. Lower = only grab ones that get close (less junk); higher = catch them earlier/farther.", 40)
    prj:Section("Captured (Replace / Add)")
    prj:Wide(function(holder) buildPlayerTiming(holder, F, State) end, 320, nil)

    prj:Section("Learn on Misses (you choose what to Add)")
    prj:Wide(function(holder) buildLearnOnMiss(holder, F, State) end, 320, nil)

    --========================================
    -- SETTINGS — top-to-bottom flow:
    --   Appearance (theme/accent/scale)  →  Interface (HUDs)
    --   →  Keybinds  →  Profiles  →  Performance  →  Reset  →  Script
    --========================================
    local set = W:Tab("Settings", "⚙️")

    set:Section("Appearance")
    set:Dropdown("Theme", { "Purple", "Black", "Midnight", "Abyss", "Light" },
        function() return Settings.get("theme", "Purple") end,
        function(t) Library.setTheme(t); F.Notification.send("Theme", t, 1.5) end,
        "Recolor the whole UI instantly.")
    set:Dropdown("Accent Color",
        { "Purple", "Blue", "Teal", "Green", "Pink", "Red", "Orange", "Gold" },
        function() return Settings.get("accent_name", "Purple") end,
        function(a) Library.setAccent(a); F.Notification.send("Accent", a, 1.5) end,
        "Pick the highlight color used across the whole UI.")
    set:Slider("UI Scale", 60, 160, function() return math.floor(W:GetScale() * 100) end,
        function(v) W:SetScale(v / 100) end, "%",
        "Resize the entire menu for your screen.", 100)

    set:Section("Interface")
    set:Toggle("Keybind HUD", function() return State.KeybindHud end,
        persistent(F.KeybindHud.setEnabled, "KeybindHud"),
        "Show the keybind list panel on the left. Enabled features glow green.")

    set:Section("Keybinds")
    local function kb(label, name, tip)
        set:Keybind(label, name,
            function() return Keybinds.get(name) end,
            function(k) Keybinds.set(name, k) end, tip)
    end
    kb("Toggle Menu",       "toggle_menu",       "Show/hide the menu.")
    kb("Panic Hide (all GUIs)", "panic_hide",    "Instantly hide/show EVERY script GUI — clear the screen before a screenshare.")
    kb("Keybind HUD",       "toggle_kbhud",      "Show/hide the on-screen keybind list.")
    kb("Toggle AutoParry",  "toggle_autoparry",  "Turn Perfect Block on/off.")
    kb("Toggle ESP",        "toggle_esp",        "Turn ESP on/off.")
    kb("Toggle Fly",        "toggle_fly",        "Turn Fly on/off.")
    kb("Toggle Noclip",     "toggle_noclip",     "Turn Noclip on/off.")
    kb("Toggle Sprint",     "toggle_sprint",     "Toggle held-sprint.")
    kb("Tween To Back",     "toggle_ttb",        "Toggle Tween To Back (attach behind nearest enemy).")
    kb("Toggle Visualizer", "toggle_visualizer", "Open/close the Animation Visualizer.")

    set:Section("Profiles")
    local profileName = "default"
    local function profileOptions()
        local list = Settings.listProfiles() or {}
        if #list == 0 then list = {"default"} end
        return list
    end
    set:Dropdown("Select Profile", profileOptions,
        function() return profileName end,
        function(p) profileName = p
            F.Notification.send("Profiles", "Selected '" .. p .. "'", 1.5)
        end,
        "Pick a saved profile, then press Load Profile to apply it.")
    set:TextInput("New Profile Name", "default", function(v) profileName = v end,
        "Type a name here, then Save Profile to create a new entry.")
    set:Button("Save Profile", function()
        if Settings.saveProfile(profileName) then
            F.Notification.send("Profiles", "Saved '" .. profileName .. "'", 2,
                Color3.fromRGB(80, 200, 130))
        end
    end, "Snapshot every toggle/value into the selected profile.")
    set:Button("Load Profile", function()
        if Settings.loadProfile(profileName) then
            F.Notification.send("Profiles", "Loaded '" .. profileName .. "' — Restart to apply", 3)
        else
            F.Notification.send("Profiles", "No profile '" .. profileName .. "'", 2,
                Color3.fromRGB(240, 96, 96))
        end
    end, "Apply the selected profile (Restart to fully apply).")
    set:Button("Delete Profile", function()
        Settings.deleteProfile(profileName)
        F.Notification.send("Profiles", "Deleted '" .. profileName .. "'", 2)
    end, "Remove the selected profile from disk.", true)

    set:Section("Performance")
    set:Toggle("Performance Mode", function() return State.LowGfx end, function(v)
        F.Visuals.setLowGfx(v); State.LowGfx = v; Settings.set("state__LowGfx", v)
    end, "No Fog · No Blur · No Shadows · No Animated Sea (same set deepwoken-rewrite removes).")

    set:Section("Reset")
    set:Button("Reset Menu Position", function()
        Settings.set("menu_pos", { x = 80, y = 80 })
        Settings.set("menu_size", { w = 580, h = 440 })
        F.Notification.send("Menu", "Position reset — Restart to apply", 2)
    end, "Move the window back to default spot/size.")
    set:Button("Reset All Settings", function()
        Settings.reset()
        F.Notification.send("Settings", "Cleared — Restart to apply", 3,
            Color3.fromRGB(240, 96, 96))
    end, "Wipe every saved preference and profile.", true)

    set:Section("Script")
    set:Button("Uninject (close)", function() Uninject.run(State) end,
        "Disable every feature and remove the menu.", true)
end

return Menu

end)
__bundle_register("Utility/Keybinds", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Keybinds: named global hotkeys. Persisted via Settings.
-- API:
--   Keybinds.register("toggle_menu", Enum.KeyCode.RightShift, callback)
--   Keybinds.set("toggle_menu", Enum.KeyCode.F1)
--   Keybinds.get("toggle_menu") -> Enum.KeyCode
local UIS = game:GetService("UserInputService")
local Settings = require("Utility/Settings")
local Conns    = require("Utility/Conns")

local Keybinds = {}
local registry = {}   -- name -> { keycode, fn }
local saved    = Settings.get("keybinds", {})

-- saved[name] can be:
--   a KeyCode name string -> that key
--   false                 -> explicitly unbound (user pressed Escape)
--   nil                   -> never set, use the default
local function resolve(name, defaultKey)
    local k = saved[name]
    if k == false then return nil end                 -- explicitly cleared
    if type(k) == "string" then return Enum.KeyCode[k] end
    return defaultKey
end

function Keybinds.register(name, defaultKey, fn)
    registry[name] = { key = resolve(name, defaultKey), fn = fn, default = defaultKey }
end
function Keybinds.set(name, key)
    if not registry[name] then return end
    registry[name].key = key
    saved[name] = key and key.Name or false          -- false = persist "none"
    Settings.set("keybinds", saved)
end
function Keybinds.get(name) return registry[name] and registry[name].key end
function Keybinds.all() return registry end

Conns.add(UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for _, b in pairs(registry) do
        if b.key and input.KeyCode == b.key and type(b.fn) == "function" then
            pcall(b.fn)
        end
    end
end))

return Keybinds

end)
__bundle_register("Features/LearnOnMiss", function(require, _LOADED, __bundle_register, __bundle_modules)
-- LearnOnMiss: a STAGING queue for timings learned by "Measure on Hit".
--
-- When an enemy move damages you, Measure-on-Hit drops the measured timing HERE
-- instead of writing it straight into your live timings — so nothing is applied
-- automatically. You review the list (Player Timing tab → "Learn on Misses") and
-- View / Add / Remove each one yourself. "Add" promotes it into your real
-- ParryTimings sheet; until you do, it does nothing.
local Http = game:GetService("HttpService")

local LearnOnMiss = {}
local FILE = "learnonmiss.json"
local staged = {}              -- array of { id, sec, cat, t }

LearnOnMiss.rev = 0
local function bump() LearnOnMiss.rev = LearnOnMiss.rev + 1 end
local function save()
    bump()
    pcall(function() writefile(FILE, Http:JSONEncode(staged)) end)
end
local function load()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then staged = t end
    end
end

function LearnOnMiss.list()  return staged end
function LearnOnMiss.count() return #staged end

-- Stage a measured ANIMATION-timing candidate. If this move is already staged,
-- refresh its time to the newest measurement instead of adding a duplicate row.
function LearnOnMiss.add(id, sec, cat)
    if not id or id == "" or type(sec) ~= "number" then return false end
    id = tostring(id)
    for _, e in ipairs(staged) do
        if e.kind == "anim" and e.id == id then e.sec = sec; e.cat = cat or e.cat; e.t = os.clock(); save(); return true end
    end
    table.insert(staged, 1, { kind = "anim", id = id, sec = sec, cat = cat or "Learn on Miss", t = os.clock() })
    while #staged > 80 do table.remove(staged) end
    save()
    return true
end

-- Stage a PROJECTILE candidate (a cero/projectile that hit you) by its part name,
-- for the Hitbox Range capture list. Deduped by name.
function LearnOnMiss.addProj(pname)
    if not pname or pname == "" then return false end
    for _, e in ipairs(staged) do
        if e.kind == "proj" and e.pname == pname then return false end
    end
    table.insert(staged, 1, { kind = "proj", pname = pname, t = os.clock() })
    while #staged > 80 do table.remove(staged) end
    save()
    return true
end

function LearnOnMiss.removeAt(idx)
    if staged[idx] then table.remove(staged, idx); save() end
end

-- Promote a staged ANIMATION candidate into the live ParryTimings sheet, then drop
-- it here. (Projectile candidates are promoted by the UI into _G.__ProjectileNames.)
function LearnOnMiss.promote(idx)
    local e = staged[idx]; if not e or e.kind ~= "anim" then return false end
    local pt = _G.__ParryTimings
    local ok = false
    if pt and pt.addParry then ok = pt.addParry(e.id, e.sec, e.cat or "Learn on Miss") end
    table.remove(staged, idx); save()
    return ok
end

function LearnOnMiss.clear() staged = {}; save() end
function LearnOnMiss.init() load() end

load()   -- load staged candidates at require-time

return LearnOnMiss
end)

__bundle_register("Features/PlayerTiming", function(require, _LOADED, __bundle_register, __bundle_modules)
-- PlayerTiming: learn YOUR parry timings by capturing them as you play.
--
-- Type Soul has no "parried" Status flag — a parry IS the block action
-- (Requests.Combat:FireServer("Block", true), the same remote AutoParry uses).
-- So we observe that remote: the moment YOU block while an enemy attack (or a
-- projectile) is nearby, we snapshot the attacker's animation id + its exact
-- TimePosition — the frame you parried at, a ready-to-use timing. The "Player
-- Timing" tab then lets you REPLACE your saved timing, ADD it as a new one, or
-- (projectiles) add the name to the Hitbox Range capture list.
--
-- Your own AutoParry blocks are ignored (Combat stamps _G.__VVBlockFired), so
-- only YOUR MANUAL parries are learned.
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local RunService = game:GetService("RunService")

local PlayerTiming = {}
local State

PlayerTiming.captured = {}      -- newest-first list of capture entries
PlayerTiming.rev = 0            -- bumps on every change (the UI polls this)
local captured = PlayerTiming.captured
local function bump() PlayerTiming.rev = PlayerTiming.rev + 1 end

local function rootOf(c)
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart"))
end

--==================== live attack-track registry ====================
-- Every currently-playing one-shot animation on any OTHER rig, so when you block
-- we can find the attack you reacted to. Only filled while the feature is on.
local liveTracks = setmetatable({}, { __mode = "k" })   -- track -> { owner, id }
local hooked     = setmetatable({}, { __mode = "k" })
local function onTrack(owner, track)
    if not (State and State.PlayerTiming) then return end
    if not owner or owner == LP.Character or track.Looped then return end
    local anim = track.Animation
    local id = anim and ((anim.AnimationId or ""):gsub("rbxassetid://", "")) or ""
    if id == "" then return end
    liveTracks[track] = { owner = owner, id = id }
    local c; c = track.Stopped:Connect(function()
        liveTracks[track] = nil
        if c then c:Disconnect() end
    end)
    Conns.add(c)
end
local function hookAnimator(an)
    if hooked[an] then return end
    hooked[an] = true
    Conns.add(an.AnimationPlayed:Connect(function(track)
        onTrack(an:FindFirstAncestorWhichIsA("Model"), track)
    end))
end

--==================== capture helpers ====================
local AV
local function animName(id)
    AV = AV or _G.__AnimViz
    return (AV and AV.resolveName and AV.resolveName(id)) or nil
end
local function pushParry(id, ms, attacker)
    for _, e in ipairs(captured) do
        if e.kind == "parry" and e.id == id and math.abs(e.ms - ms) <= 25 then return end
    end
    table.insert(captured, 1, { kind = "parry", id = id, ms = ms,
        name = animName(id), attacker = attacker, t = os.clock() })
    while #captured > 60 do table.remove(captured) end
    bump()
end
-- The travelling part is usually named the same generic thing ("Start") for many
-- different abilities, so on its own it's confusing in the Timings list. We walk up
-- the part's ancestors to the first MEANINGFUL name (the ability/model) and show
-- that as a label next to the real part name — the Add button still adds the part
-- name, the label is just so YOU can tell which projectile it was.
local GENERIC = { Start=true, Part=true, MeshPart=true, Handle=true, Hitbox=true,
    Union=true, Mesh=true, Effect=true, Effects=true, Model=true, Debris=true,
    Bone=true, Beam=true, Attachment=true, Visuals=true, Rig=true }
local function descLabel(p)
    local node = p.Parent
    for _ = 1, 5 do
        if not node or node == workspace then break end
        local n = node.Name
        if n and n ~= "" and not GENERIC[n] then return n end
        node = node.Parent
    end
    return nil
end
local function pushProj(pname, label)
    if not pname or pname == "" then return end
    for _, e in ipairs(captured) do
        if e.kind == "proj" and e.pname == pname and e.label == label then return end
    end
    table.insert(captured, 1, { kind = "proj", pname = pname, label = label, t = os.clock() })
    while #captured > 60 do table.remove(captured) end
    bump()
end

-- Nearest OTHER rig that's mid-attack within range of me.
local function nearestAttack(myPos, range)
    local best, bd
    for track, info in pairs(liveTracks) do
        if track.IsPlaying and info.owner and info.owner ~= LP.Character and info.owner.Parent then
            local r = rootOf(info.owner)
            if r then
                local d = (r.Position - myPos).Magnitude
                if d <= range and (not bd or d < bd) then bd = d; best = { id = info.id, tp = track.TimePosition, attacker = info.owner.Name } end
            end
        end
    end
    return best
end
-- Continuous PROJECTILE capture (independent of parrying). Any part that has
-- TRAVELLED and is APPROACHING you and comes within PlayerTimingProjDist studs is
-- grabbed by NAME — so you learn the REAL projectile name (the thing flying at
-- you), not the local effect particles (which spawn ON you and never "approach").
-- The distance keeps it from grabbing everything.
local projTrack = setmetatable({}, { __mode = "k" })   -- part -> {lastPos,lastDist,moved,t0,captured}
local function trackPart(p)
    if not (State and State.PlayerTiming) then return end
    if not p:IsA("BasePart") or projTrack[p] then return end
    local me = rootOf(LP.Character); if not me then return end
    if (p.Position - me.Position).Magnitude > 200 then return end   -- ignore far cross-map effects
    projTrack[p] = { lastPos = p.Position, lastDist = math.huge, moved = 0, t0 = os.clock() }
end
local lastProjT = 0
Conns.add(RunService.Heartbeat:Connect(function()
    if not (State and State.PlayerTiming) then return end
    local now = os.clock(); if now - lastProjT < 0.06 then return end; lastProjT = now
    local me = rootOf(LP.Character); if not me then return end
    local myPos = me.Position
    local capDist = State.PlayerTimingProjDist or 40
    for p, t in pairs(projTrack) do
        if not p.Parent or (now - t.t0) > 8 then
            projTrack[p] = nil
        else
            local d = (p.Position - myPos).Magnitude
            t.moved = t.moved + (p.Position - t.lastPos).Magnitude
            local approaching = d < (t.lastDist - 0.2)
            t.lastPos = p.Position; t.lastDist = d
            -- real incoming projectile: it has TRAVELLED, is APPROACHING, and is now
            -- within the capture distance. Capture each part once.
            if not t.captured and approaching and t.moved > 8 and d <= capDist then
                t.captured = true
                pushProj(p.Name, descLabel(p))
            end
        end
    end
end))

-- The heavy parry-timing capture (does :method calls — deferred, never inside the
-- namecall hook).
local function doCapture()
    if not (State and State.PlayerTiming) then return end
    local me = rootOf(LP.Character); if not me then return end
    local range = State.PlayerTimingRange or 22
    local hit = nearestAttack(me.Position, range)
    if hit then pushParry(hit.id, math.floor(hit.tp * 1000), hit.attacker) end
end
-- Called (via the namecall hook) the instant YOU fire Block. This runs INSIDE
-- the namecall, so it must be method-call-FREE — only table indexes, os.clock
-- and a defer. Doing ANY :method() here corrupts the real Block call and stops
-- you actually blocking. So we only defer the real work to just after the block.
local function onBlock()
    if not (State and State.PlayerTiming) then return end
    if _G.__VVBlockFired and (os.clock() - _G.__VVBlockFired) < 0.08 then return end   -- skip our own AutoParry blocks
    task.defer(doCapture)
end
_G.__VVPT_onBlock = onBlock      -- the persistent hook calls the LATEST module's handler

--==================== block-remote observer (installed once) ====================
local function getCombat()
    local req = RS:FindFirstChild("Requests")
    return req and req:FindFirstChild("Combat") or nil
end
local function installHook()
    if getgenv().__VVPT_hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(getnamecallmethod) ~= "function" then return end
    pcall(function()
        getgenv().__VVPT_hooked = true
        local mt  = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            -- Cheap, NO :method() before old() — only == compare + getnamecallmethod.
            -- The remote is pre-resolved into _G.__VVPT_combat (set in init).
            if getgenv().__VVPT_active and self == _G.__VVPT_combat then
                local okm, m = pcall(getnamecallmethod)
                if okm and m == "FireServer" then
                    local a1, a2 = ...
                    if a1 == "Block" and a2 == true then
                        local f = _G.__VVPT_onBlock
                        if f then pcall(f) end   -- onBlock is method-call-free + defers
                    end
                end
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

--==================== public API ====================
function PlayerTiming.setEnabled(on)
    State.PlayerTiming = on
    getgenv().__VVPT_active = on and true or false   -- gates the namecall observer cheaply
end
function PlayerTiming.clear()
    for i = #captured, 1, -1 do captured[i] = nil end
    bump()
end
function PlayerTiming.init(state)
    State = state
    getgenv().__VVPT_active = State.PlayerTiming and true or false
    -- Pre-resolve the Block remote OUTSIDE the namecall hook (so the hook never
    -- has to make a :method() call). Retry until it exists.
    _G.__VVPT_combat = getCombat()
    if not _G.__VVPT_combat then
        task.spawn(function()
            while not _G.__VVPT_combat do task.wait(1); _G.__VVPT_combat = getCombat() end
        end)
    end
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Animator") then hookAnimator(d) end
    end
    Conns.add(workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Animator") then hookAnimator(d) end
    end))
    -- Register new Debris parts for the projectile approach-tracker (gated: when
    -- the feature is off, trackPart returns immediately).
    local dbg = workspace:FindFirstChild("Debris") or workspace
    Conns.add(dbg.DescendantAdded:Connect(trackPart))
    installHook()
end

return PlayerTiming

end)
__bundle_register("Utility/StreamProof", function(require, _LOADED, __bundle_register, __bundle_modules)
-- StreamProof: hide the script's GUIs from screen capture / OBS / recordings.
-- Mirrors deepwoken-rewrite's protectgui approach, but as a toggle: ON re-parents
-- every script ScreenGui into a hidden container (gethui()/CoreGui) and calls the
-- executor's protect-gui; OFF moves them back to PlayerGui so they show normally.
-- Works purely by ScreenGui name, so it never has to touch the GUI modules.
local Players = game:GetService("Players")
local StreamProof = {}
local State

-- Every ScreenGui this script creates.
local NAMES = {
    MyMenu = true, Notifications = true, VVDebug = true,
    KeybindHud = true, AnimVisualizer = true, StreakSplash = true,
}
local PROTECT = (syn and syn.protect_gui)
    or (type(protectgui) == "function" and protectgui)
    or function() end

local function hiddenParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return Players.LocalPlayer:FindFirstChild("PlayerGui")
end

-- Find our ScreenGuis wherever they currently live.
local function collect()
    local out, seen, cands = {}, {}, {}
    pcall(function() if gethui then cands[#cands+1] = gethui() end end)
    pcall(function() cands[#cands+1] = game:GetService("CoreGui") end)
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pg then cands[#cands+1] = pg end
    for _, par in ipairs(cands) do
        local ok, kids = pcall(function() return par:GetChildren() end)
        if ok then
            for _, g in ipairs(kids) do
                if not seen[g] and g:IsA("ScreenGui") and NAMES[g.Name] then
                    seen[g] = true; out[#out + 1] = g
                end
            end
        end
    end
    return out
end

function StreamProof.set(on)
    if State then State.StreamProof = on end
    local target = on and hiddenParent()
        or (Players.LocalPlayer:FindFirstChild("PlayerGui") or hiddenParent())
    for _, g in ipairs(collect()) do
        if on then pcall(PROTECT, g) end
        pcall(function() g.Parent = target end)
    end
end

-- Panic Hide: instantly disable (or re-enable) EVERY script ScreenGui. On Volt
-- the menu/billboards can't be excluded from screen capture, so this is the
-- reliable way to make the whole UI vanish in one keystroke before sharing.
-- (Drawing-based ESP is hidden separately by Volt's own OBS Stream Proof setting.)
function StreamProof.setAllVisible(v)
    for _, g in ipairs(collect()) do pcall(function() g.Enabled = v end) end
end

function StreamProof.init(state)
    State = state
    task.defer(function() StreamProof.set(State.StreamProof ~= false) end)
end

return StreamProof

end)
__bundle_register("Utility/Logo", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Resolves the custom "Streak" logo to an Image content string usable by an
-- ImageLabel, or nil (callers fall back to text). Resolved once and cached.
--
-- Source priority:
--   1. getgenv().StreakLogo  -> a number (asset id) or a string ("rbxassetid://..."
--                               or a URL the executor can load).
--   2. a local file "streak_logo.png" in the executor's workspace, loaded via
--      getcustomasset / getsynasset (so you can just drop the PNG in the folder).
--   3. nil.
local Logo = {}
local cached, done = nil, false
local BG_URL = "https://i.ibb.co/B5sd5MBp/streaktp.png"
local function ensureFile(name, url)
    if type(isfile) ~= "function" or type(writefile) ~= "function" then return false end
    local has = false; pcall(function() has = isfile(name) end)
    if has then return true end
    local body
    pcall(function() body = game:HttpGet(url, true) end)
    if (not body or #body < 200) then
        local req = (syn and syn.request) or (http and http.request) or request or http_request
        if req then local ok, res = pcall(req, { Url = url, Method = "GET" }); if ok and res and res.Body then body = res.Body end end
    end
    if body and #body >= 200 then local ok = pcall(writefile, name, body); return ok and true or false end
    return false
end

function Logo.get()
    if done then return cached end
    done = true

    -- 1) explicit override
    local genv = (type(getgenv) == "function") and getgenv() or nil
    local id = genv and genv.StreakLogo
    if id ~= nil then
        cached = (type(id) == "number") and ("rbxassetid://" .. id) or tostring(id)
        return cached
    end

    -- 2) local workspace file via custom-asset
    local getasset = (type(getcustomasset) == "function" and getcustomasset)
        or (type(getsynasset) == "function" and getsynasset)
        or (syn and syn.getcustomasset)
    if getasset and type(isfile) == "function" then
        for _, name in ipairs({ "streak_logo.png", "streak.png", "Streak.png" }) do
            local okf = pcall(isfile, name)
            if okf and isfile(name) then
                local ok, content = pcall(getasset, name)
                if ok and content then cached = content; return cached end
            end
        end
    end

    cached = nil
    return cached
end

-- Background watermark image (the big "Streak" art). Same resolution model as
-- the logo: getgenv().StreakBackground override, else a local PNG in the
-- executor workspace loaded via custom-asset. Returns an Image string or nil.
local bgCached, bgDone = nil, false
function Logo.getBackground()
    if bgDone then return bgCached end
    bgDone = true

    local genv = (type(getgenv) == "function") and getgenv() or nil
    local id = genv and genv.StreakBackground
    if id ~= nil then
        bgCached = (type(id) == "number") and ("rbxassetid://" .. id) or tostring(id)
        return bgCached
    end

    local getasset = (type(getcustomasset) == "function" and getcustomasset)
        or (type(getsynasset) == "function" and getsynasset)
        or (syn and syn.getcustomasset)
    if getasset and type(isfile) == "function" then
        ensureFile("streaktp.png", BG_URL)
        for _, name in ipairs({ "streaktp.png", "streak_bg.png", "background.png" }) do
            local okf = pcall(isfile, name)
            if okf and isfile(name) then
                local ok, content = pcall(getasset, name)
                if ok and content then bgCached = content; return bgCached end
            end
        end
    end

    bgCached = nil
    return bgCached
end

return Logo

end)
__bundle_register("GUI/Splash", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Splash screen: shows the Streak logo with an animated entrance + exit, then
-- calls done() (which builds the menu). If no logo image is available it skips
-- straight to done() so nothing is delayed/blocked.
local Splash = {}
local Tween = game:GetService("TweenService")
local Logo  = require("Utility/Logo")

local QUAD = Enum.EasingStyle.Quad
local BACK = Enum.EasingStyle.Back

function Splash.show(parent, done)
    local img = Logo.get()
    if not img or not parent then
        if done then pcall(done) end
        return
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "StreakSplash"; sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 5000; sg.Parent = parent

    -- Logo ONLY — no backdrop, so the game behind stays fully visible/unaffected.
    local logo = Instance.new("ImageLabel", sg)
    logo.AnchorPoint = Vector2.new(0.5, 0.5); logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.fromOffset(440, 440); logo.BackgroundTransparency = 1
    logo.Image = img; logo.ImageTransparency = 1; logo.ScaleType = Enum.ScaleType.Fit
    logo.Rotation = -10
    local scale = Instance.new("UIScale", logo); scale.Scale = 0.5

    -- FADE IN from nothing (transparency 1 -> 0) while it pops up + straightens.
    Tween:Create(logo,  TweenInfo.new(0.8,  QUAD, Enum.EasingDirection.Out), { ImageTransparency = 0, Rotation = 0 }):Play()
    Tween:Create(scale, TweenInfo.new(0.85, BACK, Enum.EasingDirection.Out), { Scale = 1.0 }):Play()

    -- HOLD, then FADE OUT -> the menu appears once the logo is fully gone.
    task.delay(3.2, function()
        Tween:Create(scale, TweenInfo.new(0.7, BACK, Enum.EasingDirection.In), { Scale = 1.35 }):Play()
        local fade = Tween:Create(logo, TweenInfo.new(0.7, QUAD, Enum.EasingDirection.In), { ImageTransparency = 1, Rotation = 8 })
        fade:Play()
        fade.Completed:Connect(function()
            pcall(function() sg:Destroy() end)
            if done then pcall(done) end
        end)
    end)
end

return Splash

end)
__bundle_register("Utility/Conns", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Global connection tracker. Lets Uninject disconnect everything.
-- Persists across reloads via _G so a re-injection can wipe the old run.
_G.__MyMenuConns = _G.__MyMenuConns or {}
_G.__MyMenuTeardowns = _G.__MyMenuTeardowns or {}

local Conns = {}

function Conns.add(c)
    table.insert(_G.__MyMenuConns, c)
    return c
end

-- Register a cleanup callback (e.g. destroy GUI / restore Lighting)
function Conns.onTeardown(fn)
    table.insert(_G.__MyMenuTeardowns, fn)
end

function Conns.teardown()
    for _, c in ipairs(_G.__MyMenuConns) do
        pcall(function() c:Disconnect() end)
    end
    _G.__MyMenuConns = {}
    for _, fn in ipairs(_G.__MyMenuTeardowns) do
        pcall(fn)
    end
    _G.__MyMenuTeardowns = {}
end

return Conns

end)
__bundle_register("Utility/Settings", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Settings: persisted preferences. Saves on change to settings.json.
-- Designed so any feature can `Settings.get(key)` / `Settings.set(key, v)`
-- without caring how persistence works.
local Http = game:GetService("HttpService")
local Settings = {}
local FILE = "settings.json"
local data = {}

local function load()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then data = t end
    end
end

-- Debounced save: slider drags spam Settings.set many times per frame. Writing
-- the JSON to disk every single time was a measurable hitch; instead we mark
-- the file dirty and write at most once every ~250ms (and once immediately
-- after the last edit settles).
local dirty, scheduled = false, false
local function flush()
    if not dirty then return end
    dirty = false
    pcall(function() writefile(FILE, Http:JSONEncode(data)) end)
end
local function save()
    dirty = true
    if scheduled then return end
    scheduled = true
    task.delay(0.25, function() scheduled = false; flush() end)
end

function Settings.get(key, default) return data[key] == nil and default or data[key] end
function Settings.set(key, v) data[key] = v; save() end
function Settings.all() return data end
function Settings.reset() data = {}; dirty = true; flush() end
-- Force an immediate write (used on critical exits).
function Settings.flush() flush() end

-- ===== Profiles =====
-- A profile is a snapshot of every "state__*" key. Saved under data.profiles.
function Settings.saveProfile(name)
    if not name or name == "" then return false end
    data.profiles = data.profiles or {}
    local snap = {}
    for k, v in pairs(data) do
        if type(k) == "string" and k:sub(1, 7) == "state__" then snap[k] = v end
    end
    data.profiles[name] = snap
    save()
    return true
end
function Settings.loadProfile(name)
    local p = data.profiles and data.profiles[name]
    if not p then return false end
    for k, v in pairs(p) do data[k] = v end
    save()
    return true
end
function Settings.deleteProfile(name)
    if data.profiles then data.profiles[name] = nil; save() end
end
function Settings.listProfiles()
    local out = {}
    if data.profiles then for k in pairs(data.profiles) do table.insert(out, k) end end
    table.sort(out)
    return out
end

load()
-- Make sure any debounced edit is flushed before the script is unloaded.
local okConns, Conns = pcall(require, "Utility/Conns")
if okConns and Conns and Conns.onTeardown then
    Conns.onTeardown(function() pcall(flush) end)
end
return Settings

end)
__bundle_register("Utility/Uninject", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Uninject + Restart helpers.
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Conns = require("Utility/Conns")

local Uninject = {}

local function clearAllFlags(State)
    -- Flip every boolean-looking field off so live loops short-circuit.
    for k, v in pairs(State) do
        if type(v) == "boolean" then State[k] = false end
    end
end

function Uninject.run(State)
    clearAllFlags(State)
    Conns.teardown()
    local guis = { LP:FindFirstChild("PlayerGui") }
    pcall(function() if gethui then table.insert(guis, gethui()) end end)
    for _, p in ipairs(guis) do
        if p then
            local o = p:FindFirstChild("MyMenu")
            if o then o:Destroy() end
        end
    end
end

function Uninject.restart(State)
    Uninject.run(State)
    task.defer(function() loadstring(readfile("Main.lua"))() end)
end

return Uninject

end)
__bundle_register("GUI/TimingsManager", function(require, _LOADED, __bundle_register, __bundle_modules)
-- TimingsManager: drop-in widget for the menu's Timings tab.
-- Renders a full management UI: list of all timings with name, id, ms,
-- category; search; per-row edit/delete/preview; quick-add; bulk ops.
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Conns = require("Utility/Conns")

local TimingsManager = {}

-- Theme to match Library
local C = {
    bg     = Color3.fromRGB(24, 24, 30),
    row    = Color3.fromRGB(40, 40, 50),
    rowAlt = Color3.fromRGB(46, 46, 58),
    accent = Color3.fromRGB(96, 175, 255),
    green  = Color3.fromRGB(60, 200, 120),
    red    = Color3.fromRGB(220, 90, 90),
    text   = Color3.fromRGB(220, 220, 230),
    dim    = Color3.fromRGB(150, 160, 180),
    border = Color3.fromRGB(50, 50, 65),
}
local function corner(i, r) local c = Instance.new("UICorner", i); c.CornerRadius = UDim.new(0, r or 4); return c end

local search = ""
local catFilter = "All"

function TimingsManager.build(parent, deps)
    -- deps.timings (ParryTimings module), deps.notify, deps.openVisualizer(id)
    local PT     = deps.timings
    local notify = deps.notify or function() end
    local openV  = deps.openVisualizer or function() end
    local resolveName = deps.resolveName or function() return nil end

    local root = Instance.new("Frame")
    root.Size = UDim2.new(1, 0, 1, 0)
    root.BackgroundTransparency = 1
    root.Parent = parent

    -- ============ TOP: search + category dropdown + add bar ============
    local topRow = Instance.new("Frame", root)
    topRow.Size = UDim2.new(1, 0, 0, 28)
    topRow.BackgroundTransparency = 1

    local searchBox = Instance.new("TextBox", topRow)
    searchBox.Size = UDim2.new(0.45, -4, 1, 0)
    searchBox.BackgroundColor3 = C.bg; searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Search name / id / category…"
    searchBox.Text = ""; searchBox.TextColor3 = C.text
    searchBox.TextSize = 12; searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    local sPad = Instance.new("UIPadding", searchBox); sPad.PaddingLeft = UDim.new(0, 8)
    corner(searchBox)

    local catBtn = Instance.new("TextButton", topRow)
    catBtn.Size = UDim2.new(0.25, -4, 1, 0); catBtn.Position = UDim2.new(0.45, 4, 0, 0)
    catBtn.BackgroundColor3 = C.row; catBtn.BorderSizePixel = 0
    catBtn.Text = "All categories  v"
    catBtn.TextColor3 = C.text; catBtn.TextSize = 12; catBtn.Font = Enum.Font.GothamBold
    corner(catBtn)

    local statsLbl = Instance.new("TextLabel", topRow)
    statsLbl.Size = UDim2.new(0.30, -4, 1, 0); statsLbl.Position = UDim2.new(0.70, 4, 0, 0)
    statsLbl.BackgroundColor3 = C.row; statsLbl.BorderSizePixel = 0
    statsLbl.Text = "0 / 0"
    statsLbl.TextColor3 = C.dim; statsLbl.TextSize = 12; statsLbl.Font = Enum.Font.Code
    statsLbl.TextXAlignment = Enum.TextXAlignment.Center
    corner(statsLbl)

    -- Quick add bar
    local addRow = Instance.new("Frame", root)
    addRow.Size = UDim2.new(1, 0, 0, 28); addRow.Position = UDim2.new(0, 0, 0, 32)
    addRow.BackgroundTransparency = 1

    local idIn = Instance.new("TextBox", addRow)
    idIn.Size = UDim2.new(0.45, -4, 1, 0)
    idIn.BackgroundColor3 = C.bg; idIn.BorderSizePixel = 0
    idIn.PlaceholderText = "Animation id"; idIn.Text = ""
    idIn.TextColor3 = C.text; idIn.TextSize = 12; idIn.Font = Enum.Font.Code
    idIn.ClearTextOnFocus = false; idIn.TextXAlignment = Enum.TextXAlignment.Left
    local idPad = Instance.new("UIPadding", idIn); idPad.PaddingLeft = UDim.new(0, 8)
    corner(idIn)

    local msIn = Instance.new("TextBox", addRow)
    msIn.Size = UDim2.new(0.20, -4, 1, 0); msIn.Position = UDim2.new(0.45, 4, 0, 0)
    msIn.BackgroundColor3 = C.bg; msIn.BorderSizePixel = 0
    msIn.PlaceholderText = "ms"; msIn.Text = ""
    msIn.TextColor3 = C.text; msIn.TextSize = 12; msIn.Font = Enum.Font.Code
    msIn.ClearTextOnFocus = false; msIn.TextXAlignment = Enum.TextXAlignment.Left
    local msPad = Instance.new("UIPadding", msIn); msPad.PaddingLeft = UDim.new(0, 8)
    corner(msIn)

    local catIn = Instance.new("TextBox", addRow)
    catIn.Size = UDim2.new(0.20, -4, 1, 0); catIn.Position = UDim2.new(0.65, 4, 0, 0)
    catIn.BackgroundColor3 = C.bg; catIn.BorderSizePixel = 0
    catIn.PlaceholderText = "Category"; catIn.Text = ""
    catIn.TextColor3 = C.text; catIn.TextSize = 12; catIn.Font = Enum.Font.Gotham
    catIn.ClearTextOnFocus = false; catIn.TextXAlignment = Enum.TextXAlignment.Left
    local cPad = Instance.new("UIPadding", catIn); cPad.PaddingLeft = UDim.new(0, 8)
    corner(catIn)

    local addBtn = Instance.new("TextButton", addRow)
    addBtn.Size = UDim2.new(0.15, -4, 1, 0); addBtn.Position = UDim2.new(0.85, 4, 0, 0)
    addBtn.BackgroundColor3 = C.green; addBtn.BorderSizePixel = 0
    addBtn.Text = "Save"; addBtn.TextColor3 = Color3.fromRGB(255,255,255)
    addBtn.TextSize = 12; addBtn.Font = Enum.Font.GothamBold
    corner(addBtn)

    -- ============ LIST ============
    local list = Instance.new("ScrollingFrame", root)
    list.Size = UDim2.new(1, 0, 1, -100); list.Position = UDim2.new(0, 0, 0, 64)
    list.BackgroundColor3 = C.bg; list.BorderSizePixel = 0
    list.CanvasSize = UDim2.new(0, 0, 0, 0); list.ScrollBarThickness = 4
    corner(list)
    local listLayout = Instance.new("UIListLayout", list)
    listLayout.Padding = UDim.new(0, 2); listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ============ BOTTOM: bulk actions ============
    local botRow = Instance.new("Frame", root)
    botRow.Size = UDim2.new(1, 0, 0, 28); botRow.Position = UDim2.new(0, 0, 1, -28)
    botRow.BackgroundTransparency = 1
    local botLayout = Instance.new("UIListLayout", botRow)
    botLayout.FillDirection = Enum.FillDirection.Horizontal
    botLayout.Padding = UDim.new(0, 4)
    local function bb(label, color, fn, w)
        local b = Instance.new("TextButton", botRow)
        b.Size = UDim2.new(0, w or 100, 1, 0); b.BackgroundColor3 = color
        b.BorderSizePixel = 0; b.Text = label; b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextSize = 12; b.Font = Enum.Font.GothamBold
        corner(b)
        b.MouseButton1Click:Connect(fn)
        return b
    end

    -- Forward declare so we can refer in handlers
    local refresh

    -- Helpers
    -- A dodge-only entry has no .sec (no parry time), so guard against nil:
    -- fall back to its first parry time, then its first dodge time, then 0.
    local function asMs(v)
        if type(v) ~= "table" then return (v or 0) * 1000 end
        local s = v.sec or (v.times and v.times[1]) or (v.dodges and v.dodges[1]) or 0
        return s * 1000
    end
    local function asCat(v) return type(v) == "table" and (v.cat or "Uncategorized") or "Uncategorized" end
    local function asSrc(v) return type(v) == "table" and (v.src or "—") or "—" end

    -- Build category dropdown
    local catList = Instance.new("Frame", topRow)
    catList.Visible = false; catList.BackgroundColor3 = C.row; catList.BorderSizePixel = 0
    catList.Position = UDim2.new(0.45, 4, 1, 4); catList.Size = UDim2.new(0.25, -4, 0, 0)
    catList.ZIndex = 10
    corner(catList)
    local catLayout = Instance.new("UIListLayout", catList)
    catLayout.Padding = UDim.new(0, 2)
    local function rebuildCatDropdown()
        for _, c in ipairs(catList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local cats = { "All" }
        for _, c in ipairs(PT.categories()) do table.insert(cats, c) end
        for _, c in ipairs(cats) do
            local b = Instance.new("TextButton", catList)
            b.Size = UDim2.new(1, 0, 0, 22); b.BackgroundColor3 = C.row
            b.BorderSizePixel = 0; b.Text = c; b.TextColor3 = C.text
            b.TextSize = 12; b.Font = Enum.Font.Gotham
            b.ZIndex = 11
            b.MouseButton1Click:Connect(function()
                catFilter = c
                catBtn.Text = c .. "  v"
                catList.Visible = false
                refresh()
            end)
        end
        catList.Size = UDim2.new(0.25, -4, 0, #cats * 24)
    end
    catBtn.MouseButton1Click:Connect(function()
        rebuildCatDropdown()
        catList.Visible = not catList.Visible
    end)

    -- Build / refresh list rows. Returns the row height so the caller can
    -- accumulate the scroll canvas correctly (rows now grow with #timings).
    local HEADER_H, LINE_H, PAD = 44, 30, 6
    local function buildRow(id, v, i)
        -- Collect this animation's parry timings (may be several).
        local times = (PT.getTimes and PT.getTimes(id)) or {}
        if #times == 0 then
            times = { (type(v) == "table" and v.sec) or (type(v) == "number" and v) or 0 }
        end
        local nT = #times
        local rowH = HEADER_H + nT * LINE_H + PAD

        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1, -4, 0, rowH)
        row.BackgroundColor3 = (i % 2 == 0) and C.rowAlt or C.row
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        corner(row)

        local name = resolveName(id) or "—"
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(1, -130, 0, 18); title.Position = UDim2.new(0, 8, 0, 4)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = C.text; title.TextSize = 13; title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left; title.TextTruncate = Enum.TextTruncate.AtEnd

        local sub = Instance.new("TextLabel", row)
        sub.Size = UDim2.new(1, -130, 0, 14); sub.Position = UDim2.new(0, 8, 0, 24)
        sub.BackgroundTransparency = 1
        sub.Text = string.format("id=%s  ·  cat=%s  ·  %d timing%s", id, asCat(v), nT, nT == 1 and "" or "s")
        sub.TextColor3 = C.dim; sub.TextSize = 11; sub.Font = Enum.Font.Code
        sub.TextXAlignment = Enum.TextXAlignment.Left; sub.TextTruncate = Enum.TextTruncate.AtEnd

        -- View (whole animation) + Delete (whole animation) on the header line.
        local previewBtn = Instance.new("TextButton", row)
        previewBtn.Size = UDim2.new(0, 56, 0, 26); previewBtn.Position = UDim2.new(1, -116, 0, 8)
        previewBtn.BackgroundColor3 = C.accent; previewBtn.BorderSizePixel = 0
        previewBtn.Text = "View"; previewBtn.TextColor3 = Color3.fromRGB(255,255,255)
        previewBtn.TextSize = 12; previewBtn.Font = Enum.Font.GothamBold
        corner(previewBtn)
        previewBtn.MouseButton1Click:Connect(function() openV(id) end)

        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 52, 0, 26); delBtn.Position = UDim2.new(1, -56, 0, 8)
        delBtn.BackgroundColor3 = C.red; delBtn.BorderSizePixel = 0
        delBtn.Text = "Delete"; delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.TextSize = 12; delBtn.Font = Enum.Font.GothamBold
        corner(delBtn)
        delBtn.MouseButton1Click:Connect(function()
            PT.remove(id)
            notify("Timings", "removed " .. id, 1.5, C.red)
            refresh()
        end)

        -- One editable line PER timing.
        for idx, sec in ipairs(times) do
            local y = HEADER_H + (idx - 1) * LINE_H
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0, 30, 0, 24); lbl.Position = UDim2.new(0, 12, 0, y)
            lbl.BackgroundTransparency = 1; lbl.Text = "#" .. idx
            lbl.TextColor3 = C.dim; lbl.TextSize = 12; lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local msBox = Instance.new("TextBox", row)
            msBox.Size = UDim2.new(0, 80, 0, 24); msBox.Position = UDim2.new(0, 46, 0, y)
            msBox.BackgroundColor3 = C.bg; msBox.BorderSizePixel = 0
            msBox.Text = tostring(math.floor(sec * 1000 + 0.5))
            msBox.TextColor3 = C.accent; msBox.TextSize = 13; msBox.Font = Enum.Font.Code
            msBox.ClearTextOnFocus = false
            corner(msBox)

            local msLbl = Instance.new("TextLabel", row)
            msLbl.Size = UDim2.new(0, 22, 0, 24); msLbl.Position = UDim2.new(0, 128, 0, y)
            msLbl.BackgroundTransparency = 1; msLbl.Text = "ms"
            msLbl.TextColor3 = C.dim; msLbl.TextSize = 11; msLbl.Font = Enum.Font.Gotham
            msLbl.TextXAlignment = Enum.TextXAlignment.Left

            local thisIdx = idx
            msBox.FocusLost:Connect(function(enter)
                if not enter then return end
                local n = tonumber(msBox.Text)
                if not n then return end
                if PT.setParryAt then PT.setParryAt(id, thisIdx, n / 1000)
                else PT.set(id, n / 1000, asCat(v)) end
                notify("Timings", string.format("%s #%d = %d ms", id, thisIdx, n), 1.5, C.green)
                refresh()    -- re-sort & re-render
            end)

            -- Per-timing remove (only show the X when there is more than one,
            -- otherwise the header Delete handles the single timing).
            if nT > 1 then
                local rm = Instance.new("TextButton", row)
                rm.Size = UDim2.new(0, 24, 0, 24); rm.Position = UDim2.new(0, 158, 0, y)
                rm.BackgroundColor3 = C.red; rm.BorderSizePixel = 0
                rm.Text = "×"; rm.TextColor3 = Color3.fromRGB(255,255,255)
                rm.TextSize = 15; rm.Font = Enum.Font.GothamBold
                corner(rm)
                rm.MouseButton1Click:Connect(function()
                    if PT.removeParryAt then PT.removeParryAt(id, thisIdx) end
                    notify("Timings", string.format("removed %s #%d", id, thisIdx), 1.5, C.red)
                    refresh()
                end)
            end
        end

        return rowH
    end

    local grouped = true          -- group by category by default
    local collapsed = {}          -- cat -> true when collapsed

    local function buildCatHeader(cat, count, order)
        local h = Instance.new("Frame", list)
        h.Size = UDim2.new(1, -4, 0, 26); h.BackgroundColor3 = C.accent
        h.BorderSizePixel = 0; h.LayoutOrder = order
        corner(h)
        local btn = Instance.new("TextButton", h)
        btn.Size = UDim2.new(1, -58, 1, 0); btn.BackgroundTransparency = 1
        btn.Text = string.format("  %s  %s   (%d)",
            collapsed[cat] and ">" or "v", cat:upper(), count)
        btn.TextColor3 = Color3.fromRGB(255,255,255); btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseButton1Click:Connect(function()
            collapsed[cat] = (not collapsed[cat]) or nil; refresh()
        end)
        -- per-category clear button
        local clr = Instance.new("TextButton", h)
        clr.Size = UDim2.new(0, 52, 0, 20); clr.Position = UDim2.new(1, -54, 0, 3)
        clr.BackgroundColor3 = C.red; clr.BorderSizePixel = 0
        clr.Text = "Clear"; clr.TextColor3 = Color3.fromRGB(255,255,255)
        clr.TextSize = 11; clr.Font = Enum.Font.GothamBold
        corner(clr)
        clr.MouseButton1Click:Connect(function()
            local n = PT.clearCategory(cat)
            notify("Timings", "cleared " .. n .. " in " .. cat, 2, C.red)
            refresh()
        end)
    end

    refresh = function()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local q = search:lower()
        local visible, total = 0, 0
        local rows = {}
        for id, v in pairs(PT.all()) do
            total = total + 1
            local name = (resolveName(id) or ""):lower()
            local cat = asCat(v):lower()
            local pass = true
            if q ~= "" then
                pass = string.find(id:lower(), q, 1, true)
                    or string.find(name, q, 1, true)
                    or string.find(cat, q, 1, true)
            end
            if pass and catFilter ~= "All" and asCat(v) ~= catFilter then pass = false end
            if pass then table.insert(rows, { id = id, v = v, ms = asMs(v), cat = asCat(v) }) end
        end

        local order, canvas = 0, 0
        if grouped then
            -- bucket by category
            local buckets, catNames = {}, {}
            for _, r in ipairs(rows) do
                if not buckets[r.cat] then buckets[r.cat] = {}; table.insert(catNames, r.cat) end
                table.insert(buckets[r.cat], r)
            end
            table.sort(catNames)
            for _, cat in ipairs(catNames) do
                local grp = buckets[cat]
                table.sort(grp, function(a, b) return a.ms < b.ms end)
                order = order + 1; buildCatHeader(cat, #grp, order); canvas = canvas + 28
                if not collapsed[cat] then
                    for _, r in ipairs(grp) do
                        order = order + 1; canvas = canvas + buildRow(r.id, r.v, order) + 2
                        visible = visible + 1
                    end
                else
                    visible = visible + #grp
                end
            end
        else
            table.sort(rows, function(a, b) return a.ms < b.ms end)
            for _, r in ipairs(rows) do
                order = order + 1; canvas = canvas + buildRow(r.id, r.v, order) + 2
                visible = visible + 1
            end
        end
        statsLbl.Text = string.format("%d / %d", visible, total)
        list.CanvasSize = UDim2.new(0, 0, 0, canvas + 8)
    end

    -- expose grouped toggle for the bottom bar
    local function toggleGrouped() grouped = not grouped; refresh(); return grouped end
    TimingsManager._toggleGrouped = toggleGrouped

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        search = searchBox.Text; refresh()
    end)

    addBtn.MouseButton1Click:Connect(function()
        local id = (idIn.Text or ""):gsub("rbxassetid://", ""):gsub("%s+", "")
        local n  = tonumber(msIn.Text)
        if id == "" or not n then
            notify("Timings", "need id + ms", 2, C.red); return
        end
        PT.set(id, n / 1000, (catIn.Text ~= "" and catIn.Text) or "Uncategorized")
        notify("Timings", "saved " .. id .. " = " .. n .. "ms", 2, C.green)
        idIn.Text = ""; msIn.Text = ""; catIn.Text = ""
        refresh()
    end)

    local grpBtn
    grpBtn = bb("Group: On", C.accent, function()
        local on = TimingsManager._toggleGrouped()
        grpBtn.Text = "Group: " .. (on and "On" or "Off")
    end, 90)
    bb("Regenerate",    C.accent, function()
        local n = PT.generate()
        notify("Timings", n .. " refreshed", 2)
        refresh()
    end)
    bb("Export → clipboard", C.row, function()
        PT.export(); notify("Timings", "JSON copied", 2)
    end, 140)
    bb("Import paste",  C.row, function()
        local cb = getclipboard or get_clipboard
        local json = cb and cb() or nil
        if not json or json == "" then
            notify("Timings", "clipboard empty", 2, C.red); return
        end
        local ok, msg = PT.import(json)
        notify("Timings", msg or "?", 2, ok and C.green or C.red)
        refresh()
    end, 120)
    bb("Clear Category", C.red, function()
        if catFilter == "All" then
            notify("Timings", "pick a category first (top filter)", 2.5, C.red); return
        end
        local n = PT.clearCategory(catFilter)
        notify("Timings", "cleared " .. n .. " in " .. catFilter, 2, C.red)
        refresh()
    end, 120)
    bb("Clear ALL",     C.red,   function()
        PT.clear(); notify("Timings", "all cleared", 2, C.red); refresh()
    end)

    refresh()
    -- Auto-refresh whenever timings change from ANY source (Player Timing's
    -- Replace/Add, the Animation Visualizer's Save, etc.) — PT.rev bumps on save.
    do
        local lastRev = -1
        Conns.add(RunService.Heartbeat:Connect(function()
            local r = PT.rev or 0
            if r ~= lastRev then lastRev = r; refresh() end
        end))
    end
    return { refresh = refresh }
end

return TimingsManager

end)
__bundle_register("GUI/Library", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Simple, reliable window library — top tab-bar layout.
-- Public API:
--   W = Library.new(parent, title, subtitle?)
--   W:TabGroup(name)               -- no-op (kept for compatibility)
--   tab = W:Tab(name, icon)
--   tab:Section(text)
--   tab:Toggle(label,getter,setter,tooltip,defaultKey?)  -- defaultKey ignored here
--   tab:Button / Slider / TextInput / Keybind / Dropdown / Custom / Wide
--   W:JumpToTab(name)  W:SetVisible W:ToggleVisible W:OnVisibleChanged
--   W:GetScale W:SetScale  W:Confirm  W:Notify
--   Library.setTheme(name)  Library.setAccent(name)  Library.themes / accents
local UIS      = game:GetService("UserInputService")
local Tween    = game:GetService("TweenService")
local RunSvc   = game:GetService("RunService")
local Settings = require("Utility/Settings")
local MouseUnlock = require("Utility/MouseUnlock")
local Conns       = require("Utility/Conns")
local Logo        = require("Utility/Logo")

local Library = {}

--==================== THEMES ====================
local THEMES = {
    -- "Streak" look: near-black background with vivid neon-purple accents (matches the logo).
    -- `glow` = the second neon flow color (purple→glow flowing borders/particles).
    Purple = { bg=Color3.fromRGB(8,6,11), bgAlt=Color3.fromRGB(14,10,20),
        bgRow=Color3.fromRGB(23,16,34), bgHover=Color3.fromRGB(52,28,86),
        border=Color3.fromRGB(98,46,158), accent=Color3.fromRGB(198,74,255),
        accent2=Color3.fromRGB(150,48,238), good=Color3.fromRGB(120,220,150),
        warn=Color3.fromRGB(250,185,85),    bad=Color3.fromRGB(250,92,122),
        text=Color3.fromRGB(246,242,252),   textDim=Color3.fromRGB(172,150,202),
        glow=Color3.fromRGB(255,95,205) },
    Midnight = { bg=Color3.fromRGB(10,12,18), bgAlt=Color3.fromRGB(18,21,30),
        bgRow=Color3.fromRGB(28,32,44), bgHover=Color3.fromRGB(44,52,72),
        border=Color3.fromRGB(46,54,74), accent=Color3.fromRGB(96,170,255),
        accent2=Color3.fromRGB(56,130,225), good=Color3.fromRGB(90,205,140),
        warn=Color3.fromRGB(245,170,70),    bad=Color3.fromRGB(240,100,100),
        text=Color3.fromRGB(236,240,250),   textDim=Color3.fromRGB(150,160,182),
        glow=Color3.fromRGB(120,200,255) },
    Abyss = { bg=Color3.fromRGB(6,8,10), bgAlt=Color3.fromRGB(12,16,18),
        bgRow=Color3.fromRGB(20,26,30), bgHover=Color3.fromRGB(28,48,52),
        border=Color3.fromRGB(34,52,56), accent=Color3.fromRGB(70,230,200),
        accent2=Color3.fromRGB(40,180,160), good=Color3.fromRGB(110,225,160),
        warn=Color3.fromRGB(245,190,90),    bad=Color3.fromRGB(245,110,120),
        text=Color3.fromRGB(235,248,246),   textDim=Color3.fromRGB(150,178,178),
        glow=Color3.fromRGB(90,235,210) },
    -- Light: a SOFT grey (not near-white) with deep, saturated accents so text,
    -- borders and the neon flow all stay readable on a light background.
    Light = { bg=Color3.fromRGB(158,163,178), bgAlt=Color3.fromRGB(172,177,191),
        bgRow=Color3.fromRGB(148,154,170), bgHover=Color3.fromRGB(130,137,158),
        border=Color3.fromRGB(108,115,138), accent=Color3.fromRGB(92,42,168),
        accent2=Color3.fromRGB(66,30,132), good=Color3.fromRGB(28,120,72),
        warn=Color3.fromRGB(158,96,16),     bad=Color3.fromRGB(178,42,64),
        text=Color3.fromRGB(16,18,28),      textDim=Color3.fromRGB(58,64,86),
        glow=Color3.fromRGB(158,24,116) },
    -- Black: pure-black OLED background with the neon-purple accents.
    Black = { bg=Color3.fromRGB(0,0,0), bgAlt=Color3.fromRGB(10,8,14),
        bgRow=Color3.fromRGB(20,16,28), bgHover=Color3.fromRGB(46,26,74),
        border=Color3.fromRGB(80,40,130), accent=Color3.fromRGB(198,74,255),
        accent2=Color3.fromRGB(150,48,238), good=Color3.fromRGB(120,220,150),
        warn=Color3.fromRGB(250,185,85),    bad=Color3.fromRGB(250,92,122),
        text=Color3.fromRGB(245,242,250),   textDim=Color3.fromRGB(165,150,195),
        glow=Color3.fromRGB(255,95,205) },
}
local ACCENTS = {
    Purple=Color3.fromRGB(198,74,255), Blue=Color3.fromRGB(96,170,255),
    Teal=Color3.fromRGB(70,230,200),    Green=Color3.fromRGB(110,220,140),
    Pink=Color3.fromRGB(245,120,200),   Red=Color3.fromRGB(245,100,110),
    Orange=Color3.fromRGB(250,165,80),  Gold=Color3.fromRGB(245,205,90),
}
Library.themes  = THEMES
Library.accents = ACCENTS

local T = THEMES[Settings.get("theme","Purple")] or THEMES.Purple
-- Choosing an accent also tints the menu text to match it — but pushed toward
-- white on dark themes (and toward black on light themes) so it stays clearly
-- READABLE while still reading as the accent hue.
local WHITE, BLACK = Color3.new(1,1,1), Color3.new(0,0,0)
local function lum(c) return 0.299*c.R + 0.587*c.G + 0.114*c.B end
local function applyAccent(c)
    T.accent = c
    if lum(T.bg) < 0.5 then            -- dark theme → brighten accent for text
        T.text    = c:Lerp(WHITE, 0.6)
        T.textDim = c:Lerp(WHITE, 0.32)
    else                                -- light theme → darken accent for text
        T.text    = c:Lerp(BLACK, 0.5)
        T.textDim = c:Lerp(BLACK, 0.25)
    end
end
do local a=Settings.get("accent_name",nil); if a and ACCENTS[a] then applyAccent(ACCENTS[a]) end end
local registry = {}
local function reapply()
    for _, r in ipairs(registry) do
        for prop, key in pairs(r.map) do pcall(function() r.inst[prop] = T[key] end) end
    end
end
function Library.setTheme(name)
    local nt = THEMES[name]; if not nt then return end
    local accentName = Settings.get("accent_name", nil)
    T = setmetatable({}, { __index = nt })
    for k,v in pairs(nt) do T[k]=v end
    if accentName and ACCENTS[accentName] then applyAccent(ACCENTS[accentName]) end
    Settings.set("theme", name); reapply()
end
function Library.setAccent(name)
    local c = ACCENTS[name]; if not c then return end
    applyAccent(c); Settings.set("accent_name", name); reapply()
end

--==================== HELPERS ====================
local function ui(cls, props, parent)
    local i = Instance.new(cls)
    if props then for k,v in pairs(props) do i[k]=v end end
    if parent then i.Parent=parent end
    return i
end
local function corner(i,r) ui("UICorner",{CornerRadius=UDim.new(0,r or 8)},i) end
local function pad(i,l,t,rr,b)
    ui("UIPadding",{PaddingLeft=UDim.new(0,l or 0),PaddingTop=UDim.new(0,t or 0),
        PaddingRight=UDim.new(0,rr or 0),PaddingBottom=UDim.new(0,b or 0)},i)
end
local function bind(i, map) table.insert(registry,{inst=i,map=map}); return i end
local function stroke(i,key)
    local s=ui("UIStroke",{Color=T[key or "border"],Thickness=1,Transparency=0.2},i)
    bind(s,{Color=key or "border"}); return s
end
local function tw(i,t,p)
    Tween:Create(i,TweenInfo.new(t or 0.14,Enum.EasingStyle.Quad),p):Play()
end

--==================== NEON FX (purely visual) ====================
-- Animated, flowing purple↔pink gradient borders + soft bloom + floating
-- particles. None of this captures input or changes any layout — the particle
-- frames are non-Active, so clicks pass straight through to the widgets below.
local PINK = Color3.fromRGB(255,95,205)
local animGrads = {}            -- { {g=UIGradient, sp=degrees/sec}, ... }
local animDots  = {}            -- floating particle state
local menuShown = true          -- FX loops idle while the menu is hidden (saves FPS)
-- Attach a flowing 3-stop gradient (c1→c2→c1) to any stroke OR frame and have
-- it slowly rotate, giving the "light running around the edge" look.
local function flowStroke(inst, c1, c2, speed)
    local g = ui("UIGradient",{
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   c1),
            ColorSequenceKeypoint.new(0.5, c2),
            ColorSequenceKeypoint.new(1,   c1) }),
        Rotation = 0 }, inst)
    table.insert(animGrads, { g=g, sp=speed or 60 })
    return inst
end
-- Sprinkle n soft glowing dots that drift upward and twinkle.
local function spawnParticles(parent, n)
    for i=1,(n or 16) do
        local sz=math.random(2,5)
        local f=ui("Frame",{Size=UDim2.fromOffset(sz,sz),
            BackgroundColor3=(i%2==0) and T.accent or (T.glow or PINK),
            BackgroundTransparency=0.55,BorderSizePixel=0,ZIndex=5,Active=false,
            Position=UDim2.new(math.random(),0,math.random(),0),Parent=parent})
        ui("UICorner",{CornerRadius=UDim.new(1,0)},f)
        table.insert(animDots,{ f=f, sp=0.02+math.random()*0.05,
            dx=(math.random()-0.5)*0.03, base=0.45+math.random()*0.2,
            tw=1+math.random()*2, ph=math.random()*6.28 })
    end
end
-- ONE driver loop for every gradient + particle. Idles entirely while the menu
-- is hidden (zero in-game cost), and when open it's throttled to ~30 fps — the
-- flow looks identical but costs ~half a per-frame loop. Particle motion uses
-- the ACCUMULATED dt so speed is unchanged regardless of frame rate.
local FX_DT, fxAccum = 1/30, 0
Conns.add(RunSvc.RenderStepped:Connect(function(dt)
    if not menuShown then return end
    fxAccum = fxAccum + dt
    if fxAccum < FX_DT then return end
    local step = fxAccum; fxAccum = 0
    local t = tick()
    for i=1,#animGrads do animGrads[i].g.Rotation=(t*animGrads[i].sp)%360 end
    for i=1,#animDots do
        local d=animDots[i]; local p=d.f
        local y=p.Position.Y.Scale - d.sp*step
        local x=p.Position.X.Scale + d.dx*step
        if y<-0.05 then y=1.05; x=math.random() end
        if x<0 then x=1 elseif x>1 then x=0 end
        p.Position=UDim2.new(x,0,y,0)
        p.BackgroundTransparency=d.base + 0.18*math.sin(t*d.tw + d.ph)
    end
end))

--==================== TOOLTIP ====================
local tip, tipLbl, tipTask
local function tipSetup(p)
    if tip then return end
    tip = ui("Frame",{Size=UDim2.fromOffset(0,22),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=T.bgRow,BorderSizePixel=0,Visible=false,ZIndex=300},p)
    bind(tip,{BackgroundColor3="bgRow"}); corner(tip,5); stroke(tip)
    tipLbl=ui("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,22),
        BackgroundTransparency=1,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,ZIndex=301},tip)
    bind(tipLbl,{TextColor3="text"}); pad(tipLbl,8,0,8,0)
end
local function tipFor(target,text)
    if not text or text=="" then return end
    target.MouseEnter:Connect(function()
        if tipTask then task.cancel(tipTask) end
        tipTask=task.delay(0.35,function() if tip then tipLbl.Text=text; tip.Visible=true end end)
    end)
    target.MouseLeave:Connect(function()
        if tipTask then task.cancel(tipTask); tipTask=nil end
        if tip then tip.Visible=false end
    end)
end
-- Shared slider drag: this ONE InputChanged (reused from the tooltip mover) plus
-- ONE InputEnded drive EVERY slider, instead of two global connections per slider.
local _activeSlider   -- the active slider's setter fn(mouseX), or nil
Conns.add(UIS.InputChanged:Connect(function(i)
    if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
    if _activeSlider then _activeSlider(i.Position.X) end
    if tip and tip.Visible then
        tip.Position=UDim2.fromOffset(i.Position.X+14,i.Position.Y+18)
    end
end))
Conns.add(UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then _activeSlider=nil end
end))

--==================== WINDOW ====================
function Library.new(parent, title, subtitle)
    local self = { _tabs={}, _byName={}, _active=nil, _vis={}, _getters={} }
    local window = self

    local sg = ui("ScreenGui",{Name="MyMenu",ResetOnSpawn=false,DisplayOrder=1000,
        IgnoreGuiInset=true,Parent=parent})
    self.gui = sg
    tipSetup(sg)

    local pos  = Settings.get("menu_pos",{x=120,y=90})
    local size = Settings.get("menu_size",{w=640,h=440})

    local W = ui("Frame",{Size=UDim2.fromOffset(size.w,size.h),
        Position=UDim2.fromOffset(pos.x,pos.y),BackgroundColor3=T.bg,
        BorderSizePixel=0,ClipsDescendants=true,Parent=sg})
    bind(W,{BackgroundColor3="bg"}); corner(W,12)
    -- Neon accent border — bright glowing edge with flowing purple↔pink light.
    do local ws=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Transparency=0.05},W)
        flowStroke(ws, T.accent, (T.glow or PINK), 70) end
    self.window = W

    -- Neon purple bloom / drop shadow around the window.
    local sh=ui("ImageLabel",{Size=UDim2.new(1,56,1,56),Position=UDim2.fromOffset(-28,-24),
        BackgroundTransparency=1,Image="rbxassetid://6014261993",
        ImageColor3=T.accent,ImageTransparency=0.4,ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Parent=W})
    bind(sh,{ImageColor3="accent"})
    -- Second, wider pink bloom layer for the purple+pink glow blend.
    ui("ImageLabel",{Size=UDim2.new(1,84,1,84),Position=UDim2.fromOffset(-42,-36),
        BackgroundTransparency=1,Image="rbxassetid://6014261993",
        ImageColor3=PINK,ImageTransparency=0.62,ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Parent=W})
    -- Floating purple/pink particles drifting behind the widgets.
    spawnParticles(W, 16)

    local uiScale = ui("UIScale",{Scale=Settings.get("ui_scale",1.0)},W)
    function self:SetScale(s) s=math.clamp(s,0.6,1.6); uiScale.Scale=s; Settings.set("ui_scale",s) end
    function self:GetScale() return uiScale.Scale end

    --======== HEADER ========
    local header = ui("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=T.bgAlt,
        BorderSizePixel=0,ZIndex=2,Parent=W})
    bind(header,{BackgroundColor3="bgAlt"})
    local strip = ui("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=3,Parent=header})
    flowStroke(strip, T.accent, (T.glow or PINK), 90)

    -- Top-left logo: the Streak image if available, otherwise the title text.
    local logoImg = Logo.get()
    local logo
    if logoImg then
        logo = ui("ImageLabel",{Size=UDim2.fromOffset(150,40),Position=UDim2.fromOffset(10,2),
            BackgroundTransparency=1,Image=logoImg,ScaleType=Enum.ScaleType.Fit,
            ZIndex=3,Parent=header})
    else
        logo = ui("TextLabel",{Size=UDim2.fromOffset(180,22),Position=UDim2.fromOffset(16,5),
            BackgroundTransparency=1,Text=title or "Menu",TextColor3=Color3.fromRGB(255,255,255),
            TextSize=17,Font=Enum.Font.GothamBlack,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=header})
    end
    if subtitle and subtitle ~= "" and not logoImg then
        local sub = ui("TextLabel",{Size=UDim2.fromOffset(180,14),Position=UDim2.fromOffset(16,24),
            BackgroundTransparency=1,Text=subtitle,TextColor3=T.textDim,
            TextSize=10,Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=header})
        bind(sub,{TextColor3="textDim"})
    end

    -- search
    local searchHolder = ui("Frame",{Size=UDim2.fromOffset(230,26),Position=UDim2.new(0.5,-115,0,9),
        BackgroundColor3=T.bg,BorderSizePixel=0,ZIndex=3,Parent=header})
    bind(searchHolder,{BackgroundColor3="bg"}); corner(searchHolder,6); flowStroke(stroke(searchHolder), T.accent, (T.glow or PINK), 55)
    ui("TextLabel",{Size=UDim2.fromOffset(24,26),BackgroundTransparency=1,Text="S",
        TextColor3=T.textDim,TextSize=12,Font=Enum.Font.GothamBold,ZIndex=4,Parent=searchHolder})
    local searchBox = ui("TextBox",{Size=UDim2.new(1,-30,1,0),Position=UDim2.fromOffset(28,0),
        BackgroundTransparency=1,Text="",PlaceholderText="Search…",TextColor3=T.text,
        PlaceholderColor3=T.textDim,TextSize=12,Font=Enum.Font.Gotham,ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=searchHolder})
    bind(searchBox,{TextColor3="text",PlaceholderColor3="textDim"})

    local function winBtn(txt,xoff,col,fn,tip2)
        local b=ui("TextButton",{Size=UDim2.fromOffset(28,24),Position=UDim2.new(1,xoff,0,10),
            BackgroundColor3=T.bgRow,BorderSizePixel=0,AutoButtonColor=false,Text=txt,
            TextColor3=col or T.text,TextSize=14,Font=Enum.Font.GothamBold,ZIndex=4,Parent=header})
        bind(b,{BackgroundColor3="bgRow"}); corner(b,6)
        b.MouseEnter:Connect(function() tw(b,0.1,{BackgroundColor3=T.bgHover}) end)
        b.MouseLeave:Connect(function() tw(b,0.1,{BackgroundColor3=T.bgRow}) end)
        b.MouseButton1Click:Connect(fn); tipFor(b,tip2); return b
    end
    winBtn("-",-72,nil,function() self:ToggleMinimize() end,"Minimize")
    winBtn("X",-38,T.bad,function() self:SetVisible(false) end,"Close (PageUp reopens)")

    --======== TAB BAR (horizontal pills) ========
    local tabBar = ui("ScrollingFrame",{Size=UDim2.new(1,-12,0,34),Position=UDim2.fromOffset(6,50),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollingDirection=Enum.ScrollingDirection.X,
        ScrollBarThickness=0,CanvasSize=UDim2.new(0,0,0,0),ZIndex=2,Parent=W})
    local tabLayout = ui("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,
        SortOrder=Enum.SortOrder.LayoutOrder},tabBar)

    --======== CONTENT ========
    local content = ui("Frame",{Size=UDim2.new(1,-12,1,-122),Position=UDim2.fromOffset(6,88),
        BackgroundColor3=T.bgAlt,BorderSizePixel=0,Parent=W})
    bind(content,{BackgroundColor3="bgAlt"}); corner(content,10); content.ClipsDescendants=true
    -- Thin glowing flowing outline on the content panel.
    do local cs=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.1},content)
        flowStroke(cs, T.accent, (T.glow or PINK), 45) end
    -- Streak watermark background — faded, centered, sitting behind every panel.
    -- ZIndex 1 (not 0) so it draws ABOVE the content panel's own dark fill even
    -- under Global ZIndexBehavior; the transparent pages/translucent panels on
    -- top still render over it (created later at the same ZIndex).
    do local bgImg=Logo.getBackground()
        if bgImg then
            ui("ImageLabel",{Size=UDim2.fromScale(0.95,0.95),Position=UDim2.fromScale(0.5,0.52),
                AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image=bgImg,
                ImageTransparency=0.55,ScaleType=Enum.ScaleType.Fit,ZIndex=1,
                Active=false,Parent=content})
        end
    end

    --======== FOOTER ========
    local footer = ui("Frame",{Size=UDim2.new(1,-12,0,22),Position=UDim2.new(0,6,1,-28),
        BackgroundColor3=T.bgAlt,BorderSizePixel=0,Parent=W})
    bind(footer,{BackgroundColor3="bgAlt"}); corner(footer,6)
    local fL=ui("TextLabel",{Size=UDim2.new(0.6,-8,1,0),Position=UDim2.fromOffset(10,0),
        BackgroundTransparency=1,Text="",TextColor3=T.textDim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=footer})
    bind(fL,{TextColor3="textDim"})
    local fR=ui("TextLabel",{Size=UDim2.new(0.4,-8,1,0),Position=UDim2.new(0.6,0,0,0),
        BackgroundTransparency=1,Text="",TextColor3=T.textDim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Right,Parent=footer})
    bind(fR,{TextColor3="textDim"})

    --======== RESIZE (3 corners: bottom-right, bottom-left, top-left) ========
    local MINW, MAXW, MINH, MAXH = 460, 1600, 300, 1100
    local rz   -- shared active-drag state across all handles + the global move listener
    -- corner = which corner the handle is on; dirX/dirY = which way size grows
    -- relative to mouse delta; moveX/moveY = whether the window's top-left moves.
    local function makeHandle(corner, anchorPos, dirX, dirY, moveX, moveY, glyph, glyphPos)
        local h = ui("TextButton",{Size=UDim2.fromOffset(18,18),Position=anchorPos,
            BackgroundTransparency=1,Text=glyph or "",TextColor3=T.textDim,TextSize=12,
            Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=6,Parent=W})
        if glyph then bind(h,{TextColor3="textDim"}) end
        Conns.add(h.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                rz = { mx=i.Position.X, my=i.Position.Y,
                       w=W.AbsoluteSize.X, h=W.AbsoluteSize.Y,
                       x=W.Position.X.Offset, y=W.Position.Y.Offset,
                       dirX=dirX, dirY=dirY, moveX=moveX, moveY=moveY }
            end
        end))
        return h
    end
    -- bottom-right (visible grip), bottom-left, top-left
    local grip = makeHandle("BR", UDim2.new(1,-20,1,-20),  1,  1, false, false, "//")
    makeHandle("BL", UDim2.new(0,2,1,-20),   -1,  1, true,  false)
    makeHandle("TL", UDim2.fromOffset(0,0),   -1, -1, true,  true)
    Conns.add(UIS.InputChanged:Connect(function(i)
        if not rz or i.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local dx = (i.Position.X - rz.mx) * rz.dirX
        local dy = (i.Position.Y - rz.my) * rz.dirY
        local newW = math.clamp(rz.w + dx, MINW, MAXW)
        local newH = math.clamp(rz.h + dy, MINH, MAXH)
        local newX = rz.moveX and (rz.x + (rz.w - newW)) or rz.x
        local newY = rz.moveY and (rz.y + (rz.h - newH)) or rz.y
        W.Size     = UDim2.fromOffset(newW, newH)
        W.Position = UDim2.fromOffset(newX, newY)
    end))
    Conns.add(UIS.InputEnded:Connect(function(i)
        if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("menu_size",{w=W.AbsoluteSize.X,h=W.AbsoluteSize.Y})
            Settings.set("menu_pos",{x=W.Position.X.Offset,y=W.Position.Y.Offset})
            rz=nil
        end
    end))

    --======== DRAG ========
    do local d,ds,sp
        Conns.add(header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true; ds=i.Position; sp=W.Position end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local dl=i.Position-ds; W.Position=UDim2.fromOffset(sp.X.Offset+dl.X,sp.Y.Offset+dl.Y) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=false; Settings.set("menu_pos",{x=W.Position.X.Offset,y=W.Position.Y.Offset}) end end))
    end

    --======== VISIBILITY ========
    self._visible=Settings.get("menu_visible",true); W.Visible=self._visible
    menuShown=self._visible                          -- match saved visibility
    self._min=false
    MouseUnlock.setSource("menu", self._visible)
    function self:SetVisible(v) self._visible=v; W.Visible=v; Settings.set("menu_visible",v)
        menuShown=v                                  -- pause/resume neon FX loops
        MouseUnlock.setSource("menu", v)
        for _,fn in ipairs(self._vis) do pcall(fn,v) end end
    function self:ToggleVisible() self:SetVisible(not self._visible) end
    function self:OnVisibleChanged(fn) table.insert(self._vis,fn) end
    function self:ToggleMinimize()
        self._min=not self._min
        content.Visible=not self._min; footer.Visible=not self._min
        tabBar.Visible=not self._min; grip.Visible=not self._min
        W.Size=self._min and UDim2.fromOffset(W.AbsoluteSize.X,44)
            or UDim2.fromOffset(Settings.get("menu_size",{w=640}).w,Settings.get("menu_size",{h=440}).h)
    end

    --======== FOOTER STATUS ========
    local fps,fr,ft=60,0,tick()
    local lastFooter=0
    Conns.add(RunSvc.Heartbeat:Connect(function()
        fr=fr+1
        local now=tick()
        if now-ft>=0.5 then fps=fr/(now-ft); fr,ft=0,now end
        if not self._visible then return end
        if now-lastFooter<0.5 then return end
        lastFooter=now
        local n=0; for _,g in ipairs(self._getters) do if g() then n=n+1 end end
        fL.Text=("%d active"):format(n)
        fR.Text=("FPS %d   %s"):format(math.floor(fps), self._active and self._active.name or "")
    end))

    --======== SEARCH ========
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=searchBox.Text:lower()
        for _,t in ipairs(self._tabs) do
            for _,r in ipairs(t._rows) do
                if r.frame then r.frame.Visible=(q=="" or r.label:lower():find(q,1,true)~=nil) end
            end
            -- A groupbox shows only if the query is empty or one of its rows matches.
            if t._groups then for _,inner in ipairs(t._groups) do
                local show=(q=="")
                if not show then for _,c in ipairs(inner:GetChildren()) do
                    if c:IsA("Frame") and c.Visible then show=true; break end
                end end
                if inner.Parent then inner.Parent.Visible=show end
            end end
            t:_resize()
        end
    end)

    --======== CONFIRM ========
    function self:Confirm(message,onYes)
        local mask=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
            BackgroundTransparency=0.55,BorderSizePixel=0,Text="",AutoButtonColor=false,
            ZIndex=600,Parent=sg})
        local dlg=ui("Frame",{Size=UDim2.fromOffset(330,140),Position=UDim2.new(0.5,-165,0.5,-70),
            BackgroundColor3=T.bgAlt,BorderSizePixel=0,ZIndex=601,Parent=mask})
        corner(dlg,10); stroke(dlg)
        ui("TextLabel",{Size=UDim2.new(1,-20,0,28),Position=UDim2.fromOffset(12,10),
            BackgroundTransparency=1,Text="Confirm",TextColor3=T.accent,TextSize=16,
            Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=602,Parent=dlg})
        ui("TextLabel",{Size=UDim2.new(1,-24,0,52),Position=UDim2.fromOffset(12,40),
            BackgroundTransparency=1,Text=message,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
            TextWrapped=true,ZIndex=602,Parent=dlg})
        local yes=ui("TextButton",{Size=UDim2.fromOffset(90,30),Position=UDim2.new(1,-194,1,-42),
            BackgroundColor3=T.bad,BorderSizePixel=0,Text="Confirm",TextColor3=Color3.new(1,1,1),
            TextSize=13,Font=Enum.Font.GothamBold,ZIndex=602,Parent=dlg}); corner(yes,6)
        local no=ui("TextButton",{Size=UDim2.fromOffset(90,30),Position=UDim2.new(1,-98,1,-42),
            BackgroundColor3=T.bgRow,BorderSizePixel=0,Text="Cancel",TextColor3=T.text,
            TextSize=13,Font=Enum.Font.GothamBold,ZIndex=602,Parent=dlg}); corner(no,6)
        no.MouseButton1Click:Connect(function() mask:Destroy() end)
        mask.MouseButton1Click:Connect(function() mask:Destroy() end)
        yes.MouseButton1Click:Connect(function() mask:Destroy(); pcall(onYes) end)
    end

    --======== TAB GROUP (no-op for compatibility) ========
    function self:TabGroup(_) end

    --======== TAB ========
    function self:Tab(name, icon)
        local tab={name=name,_rows={},_sections={},_groups={}}
        self._byName[name]=tab

        local pill=ui("TextButton",{Size=UDim2.fromOffset(0,28),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundColor3=T.bgRow,BorderSizePixel=0,AutoButtonColor=false,Text="",
            LayoutOrder=#self._tabs+1,Parent=tabBar})
        bind(pill,{BackgroundColor3="bgRow"}); corner(pill,8)
        local plbl=ui("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,28),
            BackgroundTransparency=1,Text=(icon and (icon.."  ") or "")..name,TextColor3=T.textDim,
            TextSize=13,Font=Enum.Font.GothamBold,Parent=pill})
        bind(plbl,{TextColor3="textDim"}); pad(plbl,12,0,12,0)

        local page=ui("ScrollingFrame",{Size=UDim2.new(1,-16,1,-16),Position=UDim2.fromOffset(8,8),
            BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,
            ScrollBarImageColor3=T.accent,CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=content})
        bind(page,{ScrollBarImageColor3="accent"})
        ui("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
        ui("UIPadding",{PaddingBottom=UDim.new(0,8)},page)
        tab.page=page
        function tab:_resize() end   -- AutomaticCanvasSize handles the canvas now

        -- Two-column GROUPBOX layout. :Section opens a titled, bordered box that
        -- flows into the shorter of two columns; widgets after it land inside that
        -- box. :Wide / :Custom span the full width and start a fresh column pair.
        local colsHolder, colL, colR, colHL, colHR
        local curContent, pendingTitle, ord = nil, nil, 0
        local function newCols()
            ord = ord + 1
            colsHolder=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,LayoutOrder=ord,Parent=page})
            local function col(x)
                local c=ui("Frame",{Size=UDim2.new(0.5,-5,0,0),Position=UDim2.new(x,x==0 and 0 or 5,0,0),
                    AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=colsHolder})
                ui("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},c)
                return c
            end
            colL=col(0); colR=col(0.5); colHL=0; colHR=0
        end
        local function groupbox(title)
            if not colsHolder then newCols() end
            local left = colHL <= colHR
            if left then colHL=colHL+40 else colHR=colHR+40 end
            local gb=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=T.bgAlt,BackgroundTransparency=0.3,BorderSizePixel=0,Parent=left and colL or colR})
            corner(gb,8); bind(gb,{BackgroundColor3="bgAlt"})
            local st=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.28},gb)
            flowStroke(st, T.accent, (T.glow or PINK), 36)
            ui("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},gb)
            ui("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),
                PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},gb)
            local lbl=ui("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=(title or ""):upper(),
                TextColor3=T.accent,TextSize=11,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=gb}); bind(lbl,{TextColor3="accent"})
            local inner=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,LayoutOrder=1,Parent=gb})
            ui("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},inner)
            curContent=inner; table.insert(tab._groups,inner)
        end
        local function row(h)
            if not curContent then groupbox(pendingTitle or tab.name); pendingTitle=nil end
            return ui("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,Parent=curContent})
        end

        function tab:Section(text)
            pendingTitle=text; curContent=nil   -- next widget opens a box titled this
        end

        function tab:Toggle(label,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            -- Whole-row click target (easier to hit than the small switch).
            local hit=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text="",AutoButtonColor=false,ZIndex=2,Parent=f})
            local l=ui("TextLabel",{Size=UDim2.new(1,-58,1,0),Position=UDim2.fromOffset(12,0),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=f}); bind(l,{TextColor3="text"})
            local sw=ui("Frame",{Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-46,0.5,-10),
                BackgroundColor3=getter() and T.accent or T.bg,BorderSizePixel=0,ZIndex=3,Parent=f})
            corner(sw,10)
            local kn=ui("Frame",{Size=UDim2.fromOffset(14,14),
                Position=getter() and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=4,Parent=sw}); corner(kn,7)
            local function flip()
                local v=not getter(); setter(v)
                tw(sw,0.14,{BackgroundColor3=v and T.accent or T.bg})
                tw(kn,0.14,{Position=v and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3)})
                if _G.__Notify then _G.__Notify(label, v and "ON" or "OFF", 1.2,
                    v and Color3.fromRGB(60,200,120) or Color3.fromRGB(160,160,160), "Toggle") end
            end
            hit.MouseButton1Click:Connect(flip)
            hit.MouseEnter:Connect(function() tw(f,0.1,{BackgroundColor3=T.bgHover}) end)
            hit.MouseLeave:Connect(function() tw(f,0.1,{BackgroundColor3=T.bgRow}) end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label})
            if getter then table.insert(window._getters,getter) end
            self:_resize()
        end

        function tab:Button(label,fn,tooltip,danger)
            local f=row(30)
            local b=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=danger and T.bad or T.bgRow,
                BorderSizePixel=0,AutoButtonColor=false,Text=label,TextColor3=Color3.new(1,1,1),TextSize=13,
                Font=Enum.Font.GothamBold,Parent=f}); corner(b,7)
            if not danger then bind(b,{BackgroundColor3="bgRow"}) end
            local base=danger and T.bad or T.bgRow
            b.MouseEnter:Connect(function() tw(b,0.1,{BackgroundColor3=danger and Color3.fromRGB(255,125,140) or T.accent2}) end)
            b.MouseLeave:Connect(function() tw(b,0.1,{BackgroundColor3=base}) end)
            b.MouseButton1Click:Connect(function()
                if danger then window:Confirm("Run "..label.."?",fn) else fn() end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Slider(label,min,max,getter,setter,suffix,tooltip,default)
            local f=row(44); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            local l=ui("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.fromOffset(12,4),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); bind(l,{TextColor3="text"})
            local box=ui("TextBox",{Size=UDim2.fromOffset(56,18),Position=UDim2.new(1,-(default~=nil and 86 or 62),0,4),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=tostring(getter()),TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(box,4)
            bind(box,{BackgroundColor3="bg"})
            local bar=ui("Frame",{Size=UDim2.new(1,-24,0,6),Position=UDim2.fromOffset(12,30),
                BackgroundColor3=T.bg,BorderSizePixel=0,Parent=f}); corner(bar,3); bind(bar,{BackgroundColor3="bg"})
            local fill=ui("Frame",{Size=UDim2.new((getter()-min)/(max-min),0,1,0),
                BackgroundColor3=T.accent,BorderSizePixel=0,Parent=bar}); corner(fill,3); bind(fill,{BackgroundColor3="accent"})
            -- Draggable circle knob sitting at the end of the fill (grab to slide).
            local knob=ui("Frame",{Size=UDim2.fromOffset(13,13),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(1,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0,ZIndex=4,Parent=fill})
            ui("UICorner",{CornerRadius=UDim.new(1,0)},knob)
            local kstroke=ui("UIStroke",{Color=T.accent2,Thickness=2},knob); bind(kstroke,{Color="accent2"})
            if default~=nil then
                local rb=ui("TextButton",{Size=UDim2.fromOffset(20,18),Position=UDim2.new(1,-24,0,4),
                    BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="R",TextColor3=T.textDim,
                    TextSize=11,Font=Enum.Font.GothamBold,Parent=f}); corner(rb,4)
                rb.MouseButton1Click:Connect(function() setter(default); box.Text=tostring(default)
                    fill.Size=UDim2.new((default-min)/(max-min),0,1,0) end)
                tipFor(rb,"Reset to default")
            end
            local function setv(v,fromBar)
                v=math.clamp(v,min,max); setter(v); box.Text=tostring(v)
                if fromBar then fill.Size=UDim2.new((v-min)/(max-min),0,1,0)
                else tw(fill,0.05,{Size=UDim2.new((v-min)/(max-min),0,1,0)}) end
            end
            -- Drag is driven by the shared window-level InputChanged/InputEnded
            -- (one pair for all sliders); pressing the bar or knob just registers
            -- this slider as active.
            local function dragTo(px)
                setv(math.floor(min+(max-min)*math.clamp((px-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)+0.5),true)
            end
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                _activeSlider=dragTo; dragTo(i.Position.X) end end)
            knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                _activeSlider=dragTo end end)
            box.FocusLost:Connect(function(e) if not e then return end
                local n=tonumber(box.Text); if n then setv(n) else box.Text=tostring(getter()) end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:TextInput(label,default,onSubmit,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(0,104,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local inp=ui("TextBox",{Size=UDim2.new(1,-124,0,22),Position=UDim2.new(0,116,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=default or "",TextColor3=T.text,TextSize=12,
                Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(inp,4); pad(inp,6); bind(inp,{BackgroundColor3="bg"})
            -- Commit on ANY focus loss (Enter OR clicking away), and also on
            -- every keystroke, so the value is current the instant a button is
            -- clicked — previously it only committed on Enter.
            if onSubmit then
                inp.FocusLost:Connect(function() onSubmit(inp.Text) end)
                inp:GetPropertyChangedSignal("Text"):Connect(function() onSubmit(inp.Text) end)
            end
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Keybind(label,kname,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-164,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            -- key display / rebind button
            local b=ui("TextButton",{Size=UDim2.fromOffset(92,22),Position=UDim2.new(1,-100,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() and getter().Name) or "-",
                TextColor3=T.accent,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f})
            corner(b,4); bind(b,{BackgroundColor3="bg"})
            -- small Unbind button to the left of the key button
            local ub=ui("TextButton",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-154,0.5,-11),
                BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="Unbind",
                TextColor3=T.textDim,TextSize=11,Font=Enum.Font.GothamBold,
                AutoButtonColor=false,Parent=f})
            corner(ub,4); bind(ub,{BackgroundColor3="bgHover"})
            ub.MouseEnter:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bad}) end)
            ub.MouseLeave:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bgHover}) end)
            ub.MouseButton1Click:Connect(function()
                setter(nil); b.Text="-"; b.TextColor3=T.accent
            end)
            local listening
            b.MouseButton1Click:Connect(function() if listening then return end listening=true
                b.Text="press..."; b.TextColor3=T.warn
                local c; c=UIS.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        if input.KeyCode==Enum.KeyCode.Escape then
                            setter(nil); b.Text="-"; b.TextColor3=T.accent
                        else
                            setter(input.KeyCode); b.Text=input.KeyCode.Name; b.TextColor3=T.accent
                        end
                        listening=false; if c then c:Disconnect() end end end)
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        -- KeyPicker(label, getKeyName, setKeyName, tooltip)
        -- Looks/behaves like a Keybind row (press a key, Unbind button, Escape
        -- clears) but it does NOT register a global hotkey — it just stores the
        -- chosen key NAME (a string) via setKeyName. Used for e.g. the dodge key.
        function tab:KeyPicker(label, getKeyName, setKeyName, tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-164,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local function disp() local n=getKeyName(); return (n and n~="" and n) or "-" end
            local b=ui("TextButton",{Size=UDim2.fromOffset(92,22),Position=UDim2.new(1,-100,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=disp(),
                TextColor3=T.accent,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f})
            corner(b,4); bind(b,{BackgroundColor3="bg"})
            local ub=ui("TextButton",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-154,0.5,-11),
                BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="Unbind",
                TextColor3=T.textDim,TextSize=11,Font=Enum.Font.GothamBold,
                AutoButtonColor=false,Parent=f})
            corner(ub,4); bind(ub,{BackgroundColor3="bgHover"})
            ub.MouseEnter:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bad}) end)
            ub.MouseLeave:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bgHover}) end)
            ub.MouseButton1Click:Connect(function()
                setKeyName(nil); b.Text="-"; b.TextColor3=T.accent
            end)
            local listening
            b.MouseButton1Click:Connect(function() if listening then return end listening=true
                b.Text="press..."; b.TextColor3=T.warn
                local c; c=UIS.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        if input.KeyCode==Enum.KeyCode.Escape then
                            setKeyName(nil); b.Text="-"
                        else
                            setKeyName(input.KeyCode.Name); b.Text=input.KeyCode.Name
                        end
                        b.TextColor3=T.accent
                        listening=false; if c then c:Disconnect() end end end)
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        -- Dropdown. `options` may be a table OR a function returning a table
        -- (functions are re-read each time the menu opens, so dynamic lists
        -- like saved profiles stay current).
        function tab:Dropdown(label,options,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-136,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local b=ui("TextButton",{Size=UDim2.fromOffset(118,22),Position=UDim2.new(1,-126,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() or "").."  v",TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f}); corner(b,4); bind(b,{BackgroundColor3="bg"})
            local open=ui("Frame",{Size=UDim2.fromOffset(118,0),Position=UDim2.fromOffset(0,26),
                BackgroundColor3=T.bg,BorderSizePixel=0,Visible=false,ZIndex=60,
                ClipsDescendants=true,Parent=b}); corner(open,4); stroke(open)
            local function getOpts()
                local o = type(options)=="function" and options() or options
                return o or {}
            end
            local function rebuild()
                for _,c in ipairs(open:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                local opts = getOpts()
                open.Size = UDim2.fromOffset(120, #opts*24)
                for i,opt in ipairs(opts) do
                    local o=ui("TextButton",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,(i-1)*24),
                        BackgroundColor3=T.bg,BorderSizePixel=0,Text=opt,TextColor3=T.text,TextSize=12,
                        Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=61,Parent=open})
                    o.MouseEnter:Connect(function() o.BackgroundColor3=T.bgHover end)
                    o.MouseLeave:Connect(function() o.BackgroundColor3=T.bg end)
                    o.MouseButton1Click:Connect(function() setter(opt); b.Text=opt.."  v"; open.Visible=false end)
                end
            end
            b.MouseButton1Click:Connect(function()
                if open.Visible then open.Visible=false
                else rebuild(); open.Visible=true end
            end)
            -- Keep the button text in sync with the live getter.
            tab._dropdownSyncs = tab._dropdownSyncs or {}
            table.insert(tab._dropdownSyncs, function() b.Text=(getter() or "").."  v" end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Custom(builder,h)
            colsHolder=nil; curContent=nil; ord=ord+1     -- full width: break the columns
            h=h or 200
            local box=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=T.bgAlt,BackgroundTransparency=0.3,BorderSizePixel=0,LayoutOrder=ord,Parent=page})
            corner(box,8); bind(box,{BackgroundColor3="bgAlt"})
            local st=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.28},box)
            flowStroke(st, T.accent, (T.glow or PINK), 36)
            ui("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},box)
            ui("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),
                PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},box)
            if pendingTitle then
                local lbl=ui("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=pendingTitle:upper(),
                    TextColor3=T.accent,TextSize=11,Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=box}); bind(lbl,{TextColor3="accent"})
                pendingTitle=nil
            end
            local holder=ui("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,LayoutOrder=1,Parent=box})
            builder(holder)
            colsHolder=nil; curContent=nil
        end
        function tab:Wide(builder,h,_) self:Custom(builder, h or 360) end

        local function activate()
            for _,t in ipairs(self._tabs) do
                local sel=t==tab
                t.page.Visible=sel
                tw(t._pill,0.12,{BackgroundColor3=sel and T.accent or T.bgRow})
                t._plbl.TextColor3=sel and Color3.new(1,1,1) or T.textDim
                if sel then self._active=t end
            end
            Settings.set("last_tab",tab.name)
        end
        pill.MouseEnter:Connect(function() if self._active~=tab then tw(pill,0.1,{BackgroundColor3=T.bgHover}) end end)
        pill.MouseLeave:Connect(function() if self._active~=tab then tw(pill,0.1,{BackgroundColor3=T.bgRow}) end end)
        pill.MouseButton1Click:Connect(activate)
        tab._pill=pill; tab._plbl=plbl; tab._activate=activate

        table.insert(self._tabs,tab)
        task.defer(function() tabBar.CanvasSize=UDim2.new(0,tabLayout.AbsoluteContentSize.X+12,0,0) end)
        if #self._tabs==1 then activate() end
        return tab
    end

    function self:JumpToTab(name) local t=self._byName[name]; if t then t._activate() end end
    function self:Notify(...) if _G.__Notify then _G.__Notify(...) end end
    -- Compatibility no-ops for the removed 3-column panel.
    function self:SetFeatureInfo() end

    task.defer(function()
        local last=Settings.get("last_tab",nil)
        if last and self._byName[last] then self:JumpToTab(last) end
    end)

    return self
end

return Library

end)
__bundle_register("Utility/MouseUnlock", function(require, _LOADED, __bundle_register, __bundle_modules)
-- MouseUnlock: frees the cursor while a menu window is open.
-- Many combat games (Deepwoken/VV) force MouseBehavior = LockCenter every
-- frame via the camera module, which traps the cursor. We re-assert a free
-- cursor on RenderPriority.Last (after the camera runs) so clicks land on the
-- menu. When no window wants it, we stop overriding and the game resumes.
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Conns      = require("Utility/Conns")

local MouseUnlock = {}
local sources = {}      -- name -> true (open windows that want a free cursor)
local active  = 0
local bound   = false

local function step()
    if active <= 0 then return end
    if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
    if not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
end

local function ensureBound()
    if bound then return end
    bound = true
    -- Run AFTER the camera so our setting is the final word each frame.
    pcall(function()
        RunService:BindToRenderStep("VVMenuMouse", Enum.RenderPriority.Last.Value, step)
    end)
    Conns.onTeardown(function()
        pcall(function() RunService:UnbindFromRenderStep("VVMenuMouse") end)
        bound = false
    end)
end

-- name = unique window id, on = whether that window currently wants free mouse
function MouseUnlock.setSource(name, on)
    sources[name] = on or nil
    local n = 0
    for _ in pairs(sources) do n = n + 1 end
    active = n
    if active > 0 then ensureBound() end
end

return MouseUnlock

end)
__bundle_register("Features/KeybindHud", function(require, _LOADED, __bundle_register, __bundle_modules)
-- KeybindHud: small left-side panel listing all keybinds. Enabled features
-- glow green. Draggable + position persists. Never touches mouse behavior, so
-- it can't trap the cursor (we don't register it with MouseUnlock).
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Players    = game:GetService("Players")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local Settings   = require("Utility/Settings")
local Keybinds   = require("Utility/Keybinds")

local KH = {}
local State
local gui, panel
local rowByKb = {}

-- Palette (matches the purple theme)
local C = {
    bg=Color3.fromRGB(12,10,18), row=Color3.fromRGB(26,21,38),
    on=Color3.fromRGB(120,220,150), onBg=Color3.fromRGB(26,46,32),
    text=Color3.fromRGB(238,234,248), dim=Color3.fromRGB(160,152,186),
    accent=Color3.fromRGB(180,130,255), tag=Color3.fromRGB(18,15,26),
}
local function mk(cls,p,par) local i=Instance.new(cls); if p then for k,v in pairs(p) do i[k]=v end end; if par then i.Parent=par end; return i end
local function corner(i,r) mk("UICorner",{CornerRadius=UDim.new(0,r or 6)},i) end

-- label, keybind name, optional State key that means "enabled"
local ENTRIES = {
    { "Menu",       "toggle_menu" },
    { "AutoParry",  "toggle_autoparry",  "AutoParry" },
    { "Fly",        "toggle_fly",        "Fly" },
    { "Noclip",     "toggle_noclip",     "Noclip" },
    { "ESP",        "toggle_esp",        "ESP" },
    { "Sprint",     "toggle_sprint",     "ToggleSprint" },
    { "Visualizer", "toggle_visualizer", "AnimViz" },
}

local function build()
    gui = mk("ScreenGui", { Name="KeybindHud", ResetOnSpawn=false, DisplayOrder=998,
        IgnoreGuiInset=true, Parent=KH._parent })

    local pos = Settings.get("kbhud_pos", { x=14, y=180 })
    panel = mk("Frame", { Size=UDim2.fromOffset(168, 28 + #ENTRIES*24 + 8 + 16),
        Position=UDim2.fromOffset(pos.x, pos.y), BackgroundColor3=C.bg,
        BackgroundTransparency=0.1, BorderSizePixel=0, Parent=gui })
    corner(panel,8)
    mk("UIStroke",{Color=C.accent,Thickness=1,Transparency=0.4},panel)

    local title = mk("TextLabel", { Size=UDim2.new(1,-12,0,22), Position=UDim2.fromOffset(8,4),
        BackgroundTransparency=1, Text="KEYBINDS", TextColor3=C.accent, TextSize=12,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=panel })

    -- footer hint: tells the user where to change these
    mk("TextLabel", { Size=UDim2.new(1,-12,0,14),
        Position=UDim2.fromOffset(8, 28 + #ENTRIES*24 + 4),
        BackgroundTransparency=1, Text="Change in Menu > Settings",
        TextColor3=C.dim, TextSize=10, Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=panel })

    rowByKb = {}
    for i, e in ipairs(ENTRIES) do
        local label, kbName, stateKey = e[1], e[2], e[3]
        local row = mk("Frame", { Size=UDim2.new(1,-12,0,22), Position=UDim2.fromOffset(6, 26 + (i-1)*24),
            BackgroundColor3=C.row, BorderSizePixel=0, Parent=panel })
        corner(row,5)
        local name = mk("TextLabel", { Size=UDim2.new(1,-58,1,0), Position=UDim2.fromOffset(8,0),
            BackgroundTransparency=1, Text=label, TextColor3=C.text, TextSize=12,
            Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
        local keyTag = mk("TextLabel", { Size=UDim2.fromOffset(46,16), Position=UDim2.new(1,-50,0,3),
            BackgroundColor3=C.tag, BorderSizePixel=0,
            Text="-", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code, Parent=row })
        corner(keyTag,4)
        rowByKb[kbName] = { row=row, name=name, key=keyTag, stateKey=stateKey }
    end

    -- drag whole panel (persist pos). Does NOT free the mouse, so when the
    -- game mouse is locked the panel just sits there; drag it while the menu
    -- is open (cursor free).
    local drag, ds, sp
    Conns.add(panel.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=inp.Position; sp=panel.Position end
    end))
    Conns.add(UIS.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local d=inp.Position-ds
            panel.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y)
        end
    end))
    Conns.add(UIS.InputEnded:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false
            Settings.set("kbhud_pos", { x=panel.Position.X.Offset, y=panel.Position.Y.Offset })
        end
    end))

    -- refresh loop (3Hz): only writes properties when a row actually changes,
    -- so an idle HUD does no property churn.
    local last = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if not gui or not gui.Enabled then return end
        local now = tick()
        if now-last < 0.3 then return end
        last = now
        for kbName, r in pairs(rowByKb) do
            local k = Keybinds.get(kbName)
            local keyText = k and k.Name or "-"
            if r._lastKey ~= keyText then r._lastKey = keyText; r.key.Text = keyText end
            local enabled = (r.stateKey and State[r.stateKey]) and true or false
            if r._lastOn ~= enabled then
                r._lastOn = enabled
                if enabled then
                    r.row.BackgroundColor3  = C.onBg
                    r.name.TextColor3 = C.on
                    r.key.TextColor3  = C.on
                else
                    r.row.BackgroundColor3  = C.row
                    r.name.TextColor3 = C.text
                    r.key.TextColor3  = C.dim
                end
            end
        end
    end))
end

function KH.setParent(p) KH._parent = p end
function KH.setEnabled(v)
    State.KeybindHud = v
    if v then
        if not gui then build() end
        gui.Enabled = true
    elseif gui then
        gui.Enabled = false
    end
end

function KH.init(state)
    State = state
    Conns.onTeardown(function() if gui then pcall(function() gui:Destroy() end) end; gui=nil end)
end

return KH

end)
__bundle_register("Features/AnimationVisualizer", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Animation Visualizer — clean redesign.
-- Layout is strictly column/list based (UIListLayout everywhere) so NOTHING
-- overlaps. Left = searchable/sortable animation list with categories,
-- favorites and recents. Right = viewport preview + info panel + transport
-- controls + timeline scrubber + "Save as Parry Timing" (each on its own row).
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local Settings   = require("Utility/Settings")
local MouseUnlock = require("Utility/MouseUnlock")

local AV = {}
local State

----------------------------------------------------------------------
-- THEME (reads Library theme via shared keys; falls back to purple)
----------------------------------------------------------------------
local C = {
    bg=Color3.fromRGB(8,7,12), bgAlt=Color3.fromRGB(14,12,20),
    row=Color3.fromRGB(24,20,34), hover=Color3.fromRGB(48,34,74),
    border=Color3.fromRGB(58,40,92), accent=Color3.fromRGB(180,130,255),
    accent2=Color3.fromRGB(140,86,235), text=Color3.fromRGB(245,242,252),
    dim=Color3.fromRGB(170,162,195), good=Color3.fromRGB(120,220,150),
    star=Color3.fromRGB(255,210,95),
}
local function mk(cls, props, parent)
    local i = Instance.new(cls)
    if props then for k,v in pairs(props) do i[k]=v end end
    if parent then i.Parent=parent end
    return i
end
local function corner(i,r) mk("UICorner",{CornerRadius=UDim.new(0,r or 6)},i) end
local function stroke(i,c) mk("UIStroke",{Color=c or C.border,Thickness=1},i) end

----------------------------------------------------------------------
-- DATA
----------------------------------------------------------------------
local nameCache = {}      -- id -> animation instance Name
local entityCache = {}    -- id -> cloned rig model (for preview)
local logged = {}         -- id -> { id, name, owner, cat, lastSeen }
local recents = {}        -- ordered ids, newest first
-- Normalize any persisted table to STRING keys (animation ids are numeric
-- strings; a stray number key would make JSONEncode fail on a sparse array and
-- silently wipe the whole save — which is why blacklists were vanishing).
local function normKeys(t)
    local o = {}
    if type(t) == "table" then for k, v in pairs(t) do o[tostring(k)] = v end end
    return o
end
local favorites = normKeys(Settings.get("av_favorites", {}))  -- id -> true
local blacklist = normKeys(Settings.get("av_blacklist", {}))  -- id -> true (hidden permanently)
-- Save IMMEDIATELY (not debounced): blacklisting/favoriting is a rare deliberate
-- action, so we flush to disk right away so it survives a rejoin/reload.
local function saveFavs()
    Settings.set("av_favorites", normKeys(favorites))
    if Settings.flush then Settings.flush() end
end
local function saveBL()
    Settings.set("av_blacklist", normKeys(blacklist))
    if Settings.flush then Settings.flush() end
end
AV._loadPaused = false       -- when true, new animations stop being logged

-- Categorize by name keywords.
local CATS = {
    { cat="M1",      keys={"m1","swing","slash","combo"} },
    { cat="Critical",keys={"crit"} },
    { cat="Mantra",  keys={"mantra","cast","spell","talent"} },
    { cat="Heavy",   keys={"heavy","charge","aerial","leap","slam","smash"} },
    { cat="Weapon",  keys={"sword","spear","axe","dagger","scythe","mace",
                            "katana","hammer","bow","gun","rifle","fist","punch","kick"} },
}
local function categorize(name)
    local n = (name or ""):lower()
    for _, c in ipairs(CATS) do
        for _, k in ipairs(c.keys) do
            if n:find(k, 1, true) then return c.cat end
        end
    end
    return "Other"
end

-- Build the name index from every Animation instance in the game.
local function indexAnim(inst)
    if not inst:IsA("Animation") then return end
    local raw = inst.AnimationId or ""
    local id = raw:gsub("rbxassetid://", "")
    if id == "" then return end
    if nameCache[id] then return end
    if inst.Name ~= "" and inst.Name ~= "Animation" then nameCache[id] = inst.Name end
end
task.spawn(function()
    for _, d in ipairs(game:GetDescendants()) do pcall(indexAnim, d) end
end)
Conns.add(game.DescendantAdded:Connect(function(d) pcall(indexAnim, d) end))

function AV.resolveName(id) return nameCache[tostring(id)] end
-- Public category lookup (M1 / Critical / Heavy / Mantra / Weapon / Other) for a
-- given animation id, resolved from its indexed name. Used by Combat/Visuals to
-- color the attack hitbox (Critical = red, everything else = green).
function AV.categoryOf(id) return categorize(nameCache[tostring(id)]) end

----------------------------------------------------------------------
-- LOGGING (enemy animations)
----------------------------------------------------------------------
local sourceMode = "Enemies"   -- Enemies | Self | All
local logPaused = false        -- when true, stop logging new animations
local refreshList   -- fwd

local function logAnim(track, ownerModel)
    if logPaused or AV._loadPaused then return end
    local anim = track.Animation
    if not anim then return end
    local id = (anim.AnimationId or ""):gsub("rbxassetid://", "")
    if id == "" then return end
    if blacklist[id] then return end
    -- Distance gate: skip capture from owners beyond AnimVizRange (0 = unlimited).
    local maxR = State and State.AnimVizRange or 0
    if maxR and maxR > 0 and ownerModel and LP.Character then
        local me = LP.Character:FindFirstChild("HumanoidRootPart")
        local r  = ownerModel:FindFirstChild("HumanoidRootPart")
            or ownerModel:FindFirstChildWhichIsA("BasePart")
        if me and r and (r.Position - me.Position).Magnitude > maxR then return end
    end
    local name = nameCache[id] or (anim.Name ~= "Animation" and anim.Name) or ("Anim " .. id)
    local entry = logged[id]
    if not entry then
        entry = { id=id, name=name, owner=ownerModel.Name, cat=categorize(name), lastSeen=os.clock() }
        logged[id] = entry
    else
        entry.lastSeen = os.clock()
        entry.owner = ownerModel.Name
        if nameCache[id] and entry.name ~= nameCache[id] then
            entry.name = nameCache[id]; entry.cat = categorize(entry.name)
        end
    end
    -- recents
    for i, rid in ipairs(recents) do if rid == id then table.remove(recents, i); break end end
    table.insert(recents, 1, id)
    while #recents > 30 do table.remove(recents) end
    -- cache rig for preview — but ONLY while the visualizer is open. Cloning a
    -- full rig model on every new animation id is expensive (deep clone + GC),
    -- and doing it continuously while the window is CLOSED was the main FPS hit.
    -- When open, we still snapshot rigs as they appear (same preview behaviour);
    -- when closed we just log the id (cheap) and clone lazily on preview instead.
    if AV._open and not entityCache[id] then
        local ok, c = pcall(function() return ownerModel:Clone() end)
        if ok and c then entityCache[id] = c end
    end
    if AV._open and refreshList and not AV._refreshQueued then
        AV._refreshQueued = true
        task.delay(0.2, function()
            AV._refreshQueued = false
            if AV._open and refreshList then refreshList() end
        end)
    end
end

local Humanoids = require("Utility/Humanoids")
local RunSvc2   = game:GetService("RunService")
local hooked = setmetatable({}, { __mode = "k" })
-- Shared handler: an Animator-owner (Humanoid OR AnimationController) played a
-- track. `owner` is the model it belongs to (humanoid OR custom creature rig).
local function onAnimPlayed(owner, track)
    if not owner then return end
    local isSelf = owner == LP.Character
    if sourceMode == "Enemies" and isSelf then return end
    if sourceMode == "Self" and not isSelf then return end
    logAnim(track, owner)
end
local function hookHum(hum)
    if hooked[hum] then return end
    hooked[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        onAnimPlayed(hum.Parent, track)
    end))
end
Humanoids.onAdded(hookHum)

-- Non-humanoid rigs (bosses / creatures / props) animate via an
-- AnimationController instead of a Humanoid. Hook those too so their
-- animations are logged AND their real rig is captured for preview.
local function hookController(ac)
    if hooked[ac] then return end
    hooked[ac] = true
    Conns.add(ac.AnimationPlayed:Connect(function(track)
        onAnimPlayed(ac.Parent, track)
    end))
end
-- THE reliable source: the Animator itself. Modern/replicated animations are
-- loaded on the Animator (not the Humanoid/AnimationController), so those events
-- DON'T fire — which is why some monsters' animations showed up and others
-- didn't. Hooking every Animator's AnimationPlayed catches them all.
local function hookAnimator(an)
    if hooked[an] then return end
    hooked[an] = true
    Conns.add(an.AnimationPlayed:Connect(function(track)
        onAnimPlayed(an:FindFirstAncestorWhichIsA("Model"), track)
    end))
end
do
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("AnimationController") then hookController(d)
        elseif d:IsA("Animator") then hookAnimator(d) end
    end
    Conns.add(workspace.DescendantAdded:Connect(function(d)
        if d:IsA("AnimationController") then hookController(d)
        elseif d:IsA("Animator") then hookAnimator(d) end
    end))
end

----------------------------------------------------------------------
-- UI STATE
----------------------------------------------------------------------
local parent
local gui, win
local searchText, catFilter, sortMode = "", "All", "Recent"
local selectedId
local currentTrack, previewModel, viewport, vpCam, vpWM
local playSpeed = 1.0
local paused = false

function AV.setParent(p) parent = p end

----------------------------------------------------------------------
-- PREVIEW
----------------------------------------------------------------------
-- ViewportFrames do NOT evaluate Animators, so we drive the rig manually
-- from the animation's KeyframeSequence (this is the only way to preview a
-- moving rig inside a ViewportFrame).
local KSP = game:GetService("KeyframeSequenceProvider")
local poseFrames   -- sorted array: { {t=secs, poses={[jointName]=CFrame}}, ... }
local motorMap     -- jointName -> Motor6D in the current preview model

local function clearPreview()
    if currentTrack then pcall(function() currentTrack:Stop() end); currentTrack = nil end
    poseFrames, motorMap = nil, nil
    if vpWM then for _, c in ipairs(vpWM:GetChildren()) do if c:IsA("Model") then c:Destroy() end end end
    previewModel = nil
end

-- Fetch + parse the KeyframeSequence into poseFrames. Also detect the rig type
-- the animation was authored for (R6 vs R15) from its pose names, so we can
-- preview it on a matching rig (the #1 reason a preview "won't animate" is an
-- R6 anim being shown on an R15 rig).
local function fetchKeyframes(id)
    poseFrames = {}
    local ok, seq = pcall(function()
        return KSP:GetKeyframeSequenceAsync("rbxassetid://" .. id)
    end)
    if not ok or not seq then return false, tostring(seq) end
    local kfs = {}
    for _, kf in ipairs(seq:GetChildren()) do
        if kf:IsA("Keyframe") then kfs[#kfs+1] = kf end
    end
    table.sort(kfs, function(a, b) return a.Time < b.Time end)
    local maxT, isR15 = 0, false
    for _, kf in ipairs(kfs) do
        local poses = {}
        local function walk(p)
            for _, c in ipairs(p:GetChildren()) do
                if c:IsA("Pose") then
                    poses[c.Name] = c.CFrame
                    if c.Name == "UpperTorso" or c.Name == "LowerTorso"
                    or c.Name == "LeftUpperArm" or c.Name == "RightUpperArm" then
                        isR15 = true
                    end
                    walk(c)
                end
            end
        end
        walk(kf)
        poseFrames[#poseFrames+1] = { t = kf.Time, poses = poses }
        if kf.Time > maxT then maxT = kf.Time end
    end
    if #poseFrames == 0 then return false, "no keyframes" end
    return true, maxT, (isR15 and "R15" or "R6")
end

-- Map the rig's Motor6Ds by the child-part name the poses reference.
local function mapMotors(model)
    motorMap = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part1 then motorMap[d.Part1.Name] = d end
    end
end

-- Pose the rig at time t by lerping between surrounding keyframes.
local function applyPose(t)
    if not (poseFrames and motorMap) or #poseFrames == 0 then return end
    local f0, f1 = poseFrames[1], poseFrames[#poseFrames]
    for i = 1, #poseFrames - 1 do
        if t >= poseFrames[i].t and t <= poseFrames[i+1].t then
            f0, f1 = poseFrames[i], poseFrames[i+1]; break
        end
    end
    local span  = f1.t - f0.t
    local alpha = span > 0 and (t - f0.t) / span or 0
    for joint, m in pairs(motorMap) do
        local c0, c1 = f0.poses[joint], f1.poses[joint]
        if c0 and c1 then m.Transform = c0:Lerp(c1, alpha)
        elseif c0 then m.Transform = c0
        elseif c1 then m.Transform = c1 end
    end
end
AV._applyPose = applyPose

-- Default preview rig: a CLONE of the local player's real character. Real
-- (already-simulated) rigs animate correctly inside a ViewportFrame and match
-- the game's rig type (R6/R15) — synthetic CreateHumanoidModelFromDescription
-- rigs often refuse to animate in a viewport, which is what broke playback.
local function cloneLocalChar()
    local char = LP.Character
    if not char or not char:FindFirstChildWhichIsA("Humanoid") then return nil end
    local prev = char.Archivable
    char.Archivable = true
    local ok, clone = pcall(function() return char:Clone() end)
    char.Archivable = prev
    if not ok or not clone then return nil end
    -- Strip anything that could error / interfere; keep parts + joints + humanoid.
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
        or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("Sound") then
            pcall(function() d:Destroy() end)
        end
    end
    return clone
end

-- Standard humanoid joint names (R6 + R15). If an animation's poses are all in
-- this set it's a normal humanoid anim; otherwise it's a custom rig.
local HUMANOID_JOINTS = {}
for _, n in ipairs({
    "HumanoidRootPart","Torso","Head","Left Arm","Right Arm","Left Leg","Right Leg",
    "LowerTorso","UpperTorso","LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot","RightGrip","LeftGrip","Handle",
}) do HUMANOID_JOINTS[n] = true end

-- Find the real model in the game whose part names match the animation's pose
-- names (custom mobs name their parts the same as their animation joints).
-- One pass over workspace + ReplicatedStorage, scoring each candidate model.
local function findRigForPoses(nameSet)
    local want = 0
    for _ in pairs(nameSet) do want = want + 1 end
    if want == 0 then return nil end
    local function nearestModel(inst)
        local p = inst.Parent
        while p and p ~= game do
            if p:IsA("Model") then return p end
            p = p.Parent
        end
    end
    -- Pass 1: which models contain each matched joint name.
    local nameModels = {}   -- name -> { [model]=true }
    local modelNames = {}   -- model -> { [name]=true }
    for _, container in ipairs({ workspace, game:GetService("ReplicatedStorage") }) do
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("BasePart") and nameSet[d.Name] then
                local m = nearestModel(d)
                if m then
                    nameModels[d.Name] = nameModels[d.Name] or {}
                    nameModels[d.Name][m] = true
                    modelNames[m] = modelNames[m] or {}
                    modelNames[m][d.Name] = true
                end
            end
        end
    end
    -- Frequency of each name across distinct models (common names = low weight).
    local freq = {}
    for name, models in pairs(nameModels) do
        local c = 0; for _ in pairs(models) do c = c + 1 end; freq[name] = c
    end
    -- Pass 2: score each model by SUM of 1/freq over its matched names, so a
    -- model owning rare/distinctive joints (the real rig) beats one that only
    -- shares generic names like "Head".
    local best, bestScore = nil, 0
    for m, names in pairs(modelNames) do
        local s, matched = 0, 0
        for name in pairs(names) do s = s + 1 / (freq[name] or 1); matched = matched + 1 end
        if matched >= 3 and s > bestScore then bestScore = s; best = m end
    end
    return best
end

-- Last-resort synthetic rig (only if there's no character to clone).
local fallbackRigs = {}
local function getFallbackRig(rigType)
    rigType = (rigType == "R6") and "R6" or "R15"
    local cached = fallbackRigs[rigType]
    if cached then return cached end
    local rt = (rigType == "R6") and Enum.HumanoidRigType.R6 or Enum.HumanoidRigType.R15
    local ok, m = pcall(function()
        return Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), rt)
    end)
    if ok and m then fallbackRigs[rigType] = m end
    return fallbackRigs[rigType]
end

local infoName, infoId, infoMeta, scrubFill, scrubTime, saveBtn, playBtn
local function loadPreview(id)
    selectedId = id
    clearPreview()
    AV._lastLoadId = id

    -- Parse the animation so we know its joint/part names + rig type.
    local _, _, rigType = fetchKeyframes(id)
    local nameSet = {}
    local isHumanoidAnim = true
    if poseFrames then
        for _, f in ipairs(poseFrames) do
            for n in pairs(f.poses) do
                nameSet[n] = true
                if not HUMANOID_JOINTS[n] then isHumanoidAnim = false end
            end
        end
    end

    -- Pick a rig to play on, best first:
    --   1) the captured rig that actually played this anim
    --   2) custom anim -> find the matching model in the game by part names
    --   3) humanoid anim -> a clone of YOUR real character
    --   4) synthetic fallback (last resort)
    local model
    if entityCache[id] then
        model = entityCache[id]:Clone()
    elseif not isHumanoidAnim then
        local found = findRigForPoses(nameSet)
        if found then
            local prev = found.Archivable
            found.Archivable = true
            local okc, clone = pcall(function() return found:Clone() end)
            found.Archivable = prev
            if okc and clone then
                model = clone
                entityCache[id] = clone:Clone()   -- cache for next time
            end
        end
    end
    if not model and isHumanoidAnim then model = cloneLocalChar() end
    if not model then model = cloneLocalChar() end   -- last resort for custom w/o match
    if not model then
        local fb = getFallbackRig(rigType or "R15")
        if fb then model = fb:Clone() end
    end
    if not model then
        if infoName then infoName.Text = "Could not build a rig" end
        return
    end
    -- Strip anything that could run/error or clutter the preview.
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
        or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("Sound")
        or d:IsA("ParticleEmitter") or d:IsA("Fire") or d:IsA("Smoke") then
            pcall(function() d:Destroy() end)
        end
    end
    model.Parent = vpWM
    -- Non-humanoid rigs often have no PrimaryPart; give one so PivotTo + the
    -- camera framing still work.
    if not model.PrimaryPart then
        local root = model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChild("Torso")
            or model:FindFirstChildWhichIsA("BasePart", true)
        if root then model.PrimaryPart = root end
    end
    model:PivotTo(CFrame.new(0, 0, 0))
    previewModel = model
    -- Camera setup — identical to the type-soul / deepwoken-rewrite reference.
    if model.PrimaryPart then
        local _, bbs = model:GetBoundingBox()
        vpCam.CFrame = CFrame.lookAt(
            model.PrimaryPart.Position - Vector3.new(0, 0, bbs.Magnitude),
            model.PrimaryPart.Position)
    end
    -- 3) Animator playback. ViewportFrames DO evaluate Animators (verified), so
    --    we LoadAnimation + Play at speed 0 and drive TimePosition manually.
    --    Anchor ONLY the root: the joints position every other part, and an
    --    anchored part would ignore its Motor6D (that's what froze the rig).
    local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA("BasePart")
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") then p.Anchored = (p == rootPart) end
    end
    local ac = model:FindFirstChildWhichIsA("Humanoid")
        or model:FindFirstChildWhichIsA("AnimationController")
    if not ac then ac = Instance.new("AnimationController", model) end
    local animator = ac:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", ac)
    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    local okp, err = pcall(function()
        local a = mk("Animation", { AnimationId = "rbxassetid://" .. id })
        currentTrack = animator:LoadAnimation(a)
        currentTrack.Looped = true
        currentTrack.Priority = Enum.AnimationPriority.Action
        currentTrack:Play(0.0, 100, 0.0)        -- fade 0, weight 100, speed 0
    end)
    if not okp or not currentTrack then
        currentTrack = nil
        if infoName then infoName.Text = "Failed to load — press Retry" end
        if infoMeta then infoMeta.Text = "Error: " .. tostring(err) end
        if AV._retryBtn then AV._retryBtn.Visible = true end
        return
    end
    paused = false
    if playBtn then playBtn.Text = "Pause" end
    if AV._retryBtn then AV._retryBtn.Visible = false end

    -- info panel
    local e = logged[id] or { name = nameCache[id] or ("Anim " .. id), cat = "?" }
    if infoName then infoName.Text = e.name end
    if infoId then infoId.Text = "rbxassetid://" .. id end
    local pt = _G.__ParryTimings
    if infoMeta then
        local function fmt(list)
            if not list or #list == 0 then return "none" end
            local parts = {}
            for _, s in ipairs(list) do parts[#parts+1] = math.floor(s*1000).."ms" end
            return table.concat(parts, ", ")
        end
        local parry  = pt and pt.getTimes  and pt.getTimes(id)  or {}
        local dodge  = pt and pt.getDodges and pt.getDodges(id) or {}
        infoMeta.Text = string.format("Len %.2fs  |  Parry: %s  |  Dodge: %s",
            currentTrack.Length, fmt(parry), fmt(dodge))
    end
end
AV._loadPreview = loadPreview

----------------------------------------------------------------------
-- LIST
----------------------------------------------------------------------
local listScroll, listLayout
local function rowsForView()
    local out = {}
    local q = searchText:lower()
    local viewingBL = (catFilter == "Blacklist")
    local function consider(id, e)
        e = e or logged[id]; if not e then return end
        if viewingBL then
            if not blacklist[id] then return end
        else
            if blacklist[id] then return end                 -- hide blacklisted everywhere else
            if catFilter == "Favorites" and not favorites[id] then return end
            if catFilter ~= "All" and catFilter ~= "Favorites" and catFilter ~= "Recent"
                and e.cat ~= catFilter then return end
        end
        if q ~= "" then
            local hay = (e.name .. " " .. e.id .. " " .. (e.owner or "")):lower()
            if not hay:find(q, 1, true) then return end
        end
        table.insert(out, e)
    end
    if viewingBL then
        -- Show EVERY blacklisted id, even ones not seen (logged) this session —
        -- otherwise a freshly-loaded blacklist renders empty, which reads as
        -- "my blacklist didn't save". Synthesize a minimal row when needed so
        -- the entry still shows (with its name if we've indexed it) and stays
        -- un-blacklist-able.
        for id in pairs(blacklist) do
            consider(id, logged[id] or {
                id = id, name = nameCache[id] or ("Anim " .. id),
                owner = "?", cat = categorize(nameCache[id]), lastSeen = 0,
            })
        end
    elseif catFilter == "Recent" then
        for _, id in ipairs(recents) do consider(id) end
    else
        for id in pairs(logged) do consider(id) end
        if sortMode == "Name" then
            table.sort(out, function(a,b) return a.name:lower() < b.name:lower() end)
        elseif sortMode == "Category" then
            table.sort(out, function(a,b)
                if a.cat == b.cat then return a.name:lower() < b.name:lower() end
                return a.cat < b.cat end)
        elseif sortMode == "ID" then
            table.sort(out, function(a,b) return a.id < b.id end)
        else -- Recent
            table.sort(out, function(a,b) return (a.lastSeen or 0) > (b.lastSeen or 0) end)
        end
    end
    return out
end

refreshList = function()
    if not listScroll then return end
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local rows = rowsForView()
    for i, e in ipairs(rows) do
        local row = mk("Frame", {
            Size = UDim2.new(1, -4, 0, 40),
            BackgroundColor3 = (e.id == selectedId) and C.accent2 or C.row,
            BorderSizePixel = 0, LayoutOrder = i,
        }, listScroll)
        corner(row, 5)

        local fav = mk("TextButton", {
            Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(3, 7),
            BackgroundTransparency = 1, Text = "FAV",
            TextColor3 = favorites[e.id] and C.star or C.dim,
            TextSize = 10, Font = Enum.Font.GothamBlack,
        }, row)
        fav.MouseButton1Click:Connect(function()
            favorites[e.id] = (not favorites[e.id]) or nil
            saveFavs(); refreshList()
        end)

        local nameLbl = mk("TextLabel", {
            Size = UDim2.new(1, -90, 0, 18), Position = UDim2.fromOffset(30, 3),
            BackgroundTransparency = 1, Text = e.name, TextColor3 = C.text,
            TextSize = 13, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)
        local subLbl = mk("TextLabel", {
            Size = UDim2.new(1, -90, 0, 14), Position = UDim2.fromOffset(30, 21),
            BackgroundTransparency = 1,
            Text = string.format("%s · %s", e.cat or "?", e.id),
            TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local copyBtn = mk("TextButton", {
            Size = UDim2.fromOffset(48, 16), Position = UDim2.new(1, -52, 0, 4),
            BackgroundColor3 = C.bg, BorderSizePixel = 0, Text = "Copy",
            TextColor3 = C.accent, TextSize = 11, Font = Enum.Font.GothamBold,
        }, row)
        corner(copyBtn, 4)
        copyBtn.MouseButton1Click:Connect(function()
            local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
            if cb then pcall(cb, e.id) end
            copyBtn.Text = "OK"
            task.delay(0.5, function() if copyBtn.Parent then copyBtn.Text = "Copy" end end)
        end)

        local blView = (catFilter == "Blacklist")
        local blBtn = mk("TextButton", {
            Size = UDim2.fromOffset(48, 16), Position = UDim2.new(1, -52, 0, 22),
            BackgroundColor3 = blView and C.accent2 or C.row, BorderSizePixel = 0,
            Text = blView and "Show" or "Hide",
            TextColor3 = blView and Color3.new(1,1,1) or C.dim,
            TextSize = 11, Font = Enum.Font.GothamBold,
        }, row)
        corner(blBtn, 4)
        blBtn.MouseButton1Click:Connect(function()
            if blacklist[e.id] then blacklist[e.id] = nil else blacklist[e.id] = true end
            saveBL(); refreshList()
        end)

        local click = mk("TextButton", {
            Size = UDim2.new(1, -110, 1, 0), Position = UDim2.fromOffset(28, 0),
            BackgroundTransparency = 1, Text = "",
        }, row)
        click.MouseButton1Click:Connect(function() loadPreview(e.id); refreshList() end)
    end
    listScroll.CanvasSize = UDim2.new(0, 0, 0, #rows * 44)
    if AV._refreshRail then AV._refreshRail() end   -- keep category rail in sync
    if AV._status then
        local total = 0; for _ in pairs(logged) do total = total + 1 end
        local bl = 0; for _ in pairs(blacklist) do bl = bl + 1 end
        AV._status.Text = string.format("%d shown · %d total · %d hidden%s",
            #rows, total, bl, logPaused and " · LOADING PAUSED" or "")
    end
end

----------------------------------------------------------------------
-- CATEGORY PICKER (shown when saving a parry timing)
----------------------------------------------------------------------
-- onPick(categoryName) is called with the chosen/created category.
local function promptCategory(id, timeSec, onPick, kind)
    kind = kind or "parry"
    local pt = _G.__ParryTimings
    local cats = (pt and pt.categories and pt.categories()) or {}
    -- Also offer the auto-detected category for this anim.
    local auto = (logged[id] and logged[id].cat)
    local haveAuto = false
    for _, c in ipairs(cats) do if c == auto then haveAuto = true end end
    if auto and auto ~= "" and not haveAuto then table.insert(cats, 1, auto) end

    local mask = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.55, BorderSizePixel=0, Text="", AutoButtonColor=false,
        ZIndex=400, Parent=gui })
    local dlg = mk("Frame", { Size=UDim2.fromOffset(340,360), Position=UDim2.new(0.5,-170,0.5,-180),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, ZIndex=401, Parent=mask })
    corner(dlg,10); stroke(dlg)
    mk("TextLabel", { Size=UDim2.new(1,-20,0,26), Position=UDim2.fromOffset(14,10),
        BackgroundTransparency=1,
        Text = (kind=="dodge" and "💾  Save Dodge Timing" or "💾  Save Parry Timing"),
        TextColor3=C.accent, TextSize=16,
        Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,18), Position=UDim2.fromOffset(14,38),
        BackgroundTransparency=1,
        Text=string.format("%s  @  %d ms", (logged[id] and logged[id].name) or id, math.floor(timeSec*1000)),
        TextColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,16), Position=UDim2.fromOffset(14,62),
        BackgroundTransparency=1, Text="Choose a category:", TextColor3=C.text, TextSize=12,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })

    local function finish(cat)
        if pt then
            if kind == "dodge" and pt.addDodge then pt.addDodge(id, timeSec, cat)
            elseif pt.addParry then pt.addParry(id, timeSec, cat)        -- append (allows multiple)
            elseif pt.set then pt.set(id, timeSec, cat) end
        end
        mask:Destroy()
        if onPick then onPick(cat, kind) end
    end

    -- search box: filter the category list as you type.
    local searchBox = mk("TextBox", { Size=UDim2.new(1,-24,0,26), Position=UDim2.fromOffset(12,80),
        BackgroundColor3=C.bg, BorderSizePixel=0, PlaceholderText="Search categories…",
        Text="", TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    corner(searchBox,6); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},searchBox)

    -- existing categories list (shifted down to make room for the search box)
    local listF = mk("ScrollingFrame", { Size=UDim2.new(1,-24,0,150), Position=UDim2.fromOffset(12,112),
        BackgroundColor3=C.bg, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,0), ZIndex=402, Parent=dlg })
    corner(listF,6)
    mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listF)

    local function rebuildList(query)
        query = (query or ""):lower()
        for _, c in ipairs(listF:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        local shown = 0
        for i, cat in ipairs(cats) do
            if query == "" or string.find(cat:lower(), query, 1, true) then
                shown = shown + 1
                local b = mk("TextButton", { Size=UDim2.new(1,-4,0,30), BackgroundColor3=C.row,
                    BorderSizePixel=0, Text="  "..cat, TextColor3=C.text, TextSize=13,
                    Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left,
                    LayoutOrder=i, ZIndex=403, Parent=listF })
                corner(b,5)
                b.MouseEnter:Connect(function() b.BackgroundColor3=C.hover end)
                b.MouseLeave:Connect(function() b.BackgroundColor3=C.row end)
                b.MouseButton1Click:Connect(function() finish(cat) end)
            end
        end
        if shown == 0 then
            mk("TextLabel", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                Text = (#cats == 0) and "(no categories yet — make one below)"
                    or "(no match — type below to make a new one)",
                TextColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham, ZIndex=403, Parent=listF })
        end
        listF.CanvasSize = UDim2.new(0,0,0, math.max(shown,1)*33)
    end
    rebuildList("")
    searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildList(searchBox.Text) end)

    -- new category input + create
    local newBox = mk("TextBox", { Size=UDim2.new(1,-130,0,30), Position=UDim2.fromOffset(12,272),
        BackgroundColor3=C.bg, BorderSizePixel=0, PlaceholderText="New category name…",
        Text="", TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    corner(newBox,6); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},newBox)
    local createBtn = mk("TextButton", { Size=UDim2.fromOffset(104,30), Position=UDim2.new(1,-116,0,272),
        BackgroundColor3=C.accent2, BorderSizePixel=0, Text="Create & Save", TextColor3=Color3.new(1,1,1),
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=402, Parent=dlg })
    corner(createBtn,6)
    createBtn.MouseButton1Click:Connect(function()
        local name = (newBox.Text or ""):gsub("^%s+",""):gsub("%s+$","")
        if name == "" then return end
        finish(name)
    end)

    local cancel = mk("TextButton", { Size=UDim2.new(1,-24,0,28), Position=UDim2.fromOffset(12,318),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Cancel", TextColor3=C.text,
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=402, Parent=dlg })
    corner(cancel,6)
    cancel.MouseButton1Click:Connect(function() mask:Destroy() end)
    mask.MouseButton1Click:Connect(function() mask:Destroy() end)
end

----------------------------------------------------------------------
-- REPLACE-OR-ADD PICKER
-- Shown when the animation ALREADY has parry timing(s) and the user tries
-- to save another. They can replace a specific existing timing, or add this
-- frame as an additional timing. onAdd() is called if they choose "add new".
----------------------------------------------------------------------
local function promptReplaceOrAdd(id, timeSec, existing, onChanged, onAdd, kind)
    kind = kind or "parry"
    local pt = _G.__ParryTimings
    local setAt = (kind == "dodge") and (pt and pt.setDodgeAt) or (pt and pt.setParryAt)
    local label = (kind == "dodge") and "dodge" or "parry"
    local newMs = math.floor(timeSec * 1000)
    local mask = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.55, BorderSizePixel=0, Text="", AutoButtonColor=false,
        ZIndex=410, Parent=gui })
    local listH = math.min(#existing, 6) * 33
    local dlgH  = 150 + listH + 40
    local dlg = mk("Frame", { Size=UDim2.fromOffset(360, dlgH), Position=UDim2.new(0.5,-180,0.5,-dlgH/2),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, ZIndex=411, Parent=mask })
    corner(dlg,10); stroke(dlg)
    mk("TextLabel", { Size=UDim2.new(1,-20,0,26), Position=UDim2.fromOffset(14,10), BackgroundTransparency=1,
        Text="⚠  Timing already exists", TextColor3=C.accent, TextSize=16, Font=Enum.Font.GothamBlack,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=412, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,34), Position=UDim2.fromOffset(14,38), BackgroundTransparency=1,
        Text=string.format("%s already has %d %s timing(s).\nReplace one with %d ms, or add as a new one?",
            (logged[id] and logged[id].name) or id, #existing, label, newMs),
        TextColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=412, Parent=dlg })

    local listF = mk("ScrollingFrame", { Size=UDim2.new(1,-24,0,listH), Position=UDim2.fromOffset(12,84),
        BackgroundColor3=C.bg, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,#existing*33), ZIndex=412, Parent=dlg })
    corner(listF,6)
    mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listF)
    for i, sec in ipairs(existing) do
        local b = mk("TextButton", { Size=UDim2.new(1,-4,0,30), BackgroundColor3=C.row, BorderSizePixel=0,
            Text=string.format("  Replace #%d   (%d ms  →  %d ms)", i, math.floor(sec*1000), newMs),
            TextColor3=C.text, TextSize=13, Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=i, ZIndex=413, Parent=listF })
        corner(b,5)
        b.MouseEnter:Connect(function() b.BackgroundColor3=C.hover end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=C.row end)
        b.MouseButton1Click:Connect(function()
            if setAt then setAt(id, i, timeSec) end
            mask:Destroy()
            if _G.__Notify then _G.__Notify("Timing Replaced",
                string.format("%s #%d → %d ms", (logged[id] and logged[id].name) or id, i, newMs), 2.5, C.good) end
            if onChanged then onChanged() end
        end)
    end

    local addBtn = mk("TextButton", { Size=UDim2.new(1,-24,0,30), Position=UDim2.fromOffset(12,84+listH+8),
        BackgroundColor3=C.accent2, BorderSizePixel=0,
        Text=string.format("+ Add as new timing  (now %d)", #existing+1), TextColor3=Color3.new(1,1,1),
        TextSize=13, Font=Enum.Font.GothamBold, ZIndex=412, Parent=dlg })
    corner(addBtn,6)
    addBtn.MouseButton1Click:Connect(function() mask:Destroy(); if onAdd then onAdd() end end)

    local cancel = mk("TextButton", { Size=UDim2.new(1,-24,0,26), Position=UDim2.fromOffset(12,84+listH+44),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Cancel", TextColor3=C.text,
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=412, Parent=dlg })
    corner(cancel,6)
    cancel.MouseButton1Click:Connect(function() mask:Destroy() end)
    mask.MouseButton1Click:Connect(function() mask:Destroy() end)
end

----------------------------------------------------------------------
-- BUILD WINDOW
----------------------------------------------------------------------
local function build()
    gui = mk("ScreenGui", {
        Name = "AnimVisualizer", ResetOnSpawn = false,
        DisplayOrder = 1001, IgnoreGuiInset = true, Parent = parent,
    })

    local vpos = Settings.get("av_pos", { x = 150, y = 80 })
    local vsize = Settings.get("av_size", { w = 1120, h = 860 })
    win = mk("Frame", {
        Size = UDim2.fromOffset(vsize.w, vsize.h),
        Position = UDim2.fromOffset(vpos.x, vpos.y),
        BackgroundColor3 = C.bg, BorderSizePixel = 0, Parent = gui,
    })
    corner(win, 10); stroke(win)
    -- soft shadow for premium depth
    mk("ImageLabel", { Size=UDim2.new(1,40,1,40), Position=UDim2.fromOffset(-20,-16),
        BackgroundTransparency=1, Image="rbxassetid://6014261993", ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.5, ZIndex=0, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), Parent=win })
    -- resize grip (bottom-right), persists size
    local grip = mk("TextButton", { Size=UDim2.fromOffset(16,16), Position=UDim2.new(1,-18,1,-18),
        BackgroundTransparency=1, Text="//", TextColor3=C.dim, TextSize=12, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, ZIndex=20, Parent=win })
    do local rz
        grip.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            rz={x=i.Position.X,y=i.Position.Y,w=win.AbsoluteSize.X,h=win.AbsoluteSize.Y} end end)
        Conns.add(UIS.InputChanged:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseMovement then
            win.Size=UDim2.fromOffset(math.clamp(rz.w+i.Position.X-rz.x,520,1400),
                                      math.clamp(rz.h+i.Position.Y-rz.y,340,1000)) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("av_size",{w=win.AbsoluteSize.X,h=win.AbsoluteSize.Y}); rz=nil end end))
    end

    -- ===== Header (drag + close) =====
    local header = mk("Frame", { Size = UDim2.new(1,0,0,34), BackgroundColor3 = C.bgAlt,
        BorderSizePixel = 0, Parent = win })
    corner(header, 10)
    mk("Frame", { Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=header })
    mk("TextLabel", { Size=UDim2.new(1,-80,1,0), Position=UDim2.fromOffset(14,0),
        BackgroundTransparency=1, Text="Animation Visualizer", TextColor3=C.text,
        TextSize=15, Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left,
        Parent=header })
    local closeB = mk("TextButton", { Size=UDim2.fromOffset(26,22), Position=UDim2.new(1,-32,0,6),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="×", TextColor3=C.bad and C.text,
        TextSize=16, Font=Enum.Font.GothamBold, Parent=header })
    corner(closeB,4)
    closeB.MouseButton1Click:Connect(function() AV.toggle(false) end)
    -- drag
    do
        local drag, ds, sp
        header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; sp=win.Position end end)
        Conns.add(UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds; win.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false; Settings.set("av_pos",{x=win.Position.X.Offset,y=win.Position.Y.Offset}) end end))
    end

    -- ===== Toolbar (search + source + sort) =====
    local toolbar = mk("Frame", { Size=UDim2.new(1,-16,0,28), Position=UDim2.fromOffset(8,40),
        BackgroundTransparency=1, Parent=win })

    local searchBox = mk("TextBox", { Size=UDim2.new(0.42,0,1,0), BackgroundColor3=C.bgAlt,
        BorderSizePixel=0, PlaceholderText="Search name / id…", Text="",
        TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, Parent=toolbar })
    corner(searchBox,5); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},searchBox)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchText = searchBox.Text; refreshList() end)

    -- Source + Sort cycle buttons (explicit positions; no overlap with search)
    local srcBtn = mk("TextButton", { Size=UDim2.new(0,118,1,0), Position=UDim2.new(0.44,0,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text="Src: "..sourceMode,
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=toolbar })
    corner(srcBtn,5)
    srcBtn.MouseButton1Click:Connect(function()
        local opts={"Enemies","Self","All"}; local idx=1
        for i,o in ipairs(opts) do if o==sourceMode then idx=i break end end
        sourceMode=opts[(idx%#opts)+1]; srcBtn.Text="Src: "..sourceMode
        logged={}; recents={}; refreshList()
    end)
    local sortBtn = mk("TextButton", { Size=UDim2.new(0,150,1,0), Position=UDim2.new(0.44,126,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text="Sort: "..sortMode,
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=toolbar })
    corner(sortBtn,5)
    sortBtn.MouseButton1Click:Connect(function()
        local opts={"Recent","Name","Category","ID"}; local ci=1
        for i,o in ipairs(opts) do if o==sortMode then ci=i break end end
        sortMode=opts[(ci%#opts)+1]; sortBtn.Text="Sort: "..sortMode; refreshList()
    end)

    -- ===== Second toolbar row: manual ID load + pause loading + status =====
    local row2 = mk("Frame", { Size=UDim2.new(1,-16,0,26), Position=UDim2.fromOffset(8,72),
        BackgroundTransparency=1, Parent=win })
    -- "Asset ID" label so the input is obvious as a paste section.
    mk("TextLabel", { Size=UDim2.fromOffset(58,26), Position=UDim2.fromOffset(0,0),
        BackgroundTransparency=1, Text="ASSET ID", TextColor3=C.accent,
        TextSize=11, Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left,
        Parent=row2 })
    local idBox = mk("TextBox", { Size=UDim2.new(0,294,1,0), Position=UDim2.fromOffset(62,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0,
        PlaceholderText="Paste ID or roblox.com URL…", Text="",
        TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, Parent=row2 })
    corner(idBox,5); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},idBox)
    local loadBtn = mk("TextButton", { Size=UDim2.new(0,70,1,0), Position=UDim2.fromOffset(360,0),
        BackgroundColor3=C.accent2, BorderSizePixel=0, Text="Load",
        TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(loadBtn,5)
    -- Accepts:  "1234"  "rbxassetid://1234"  "https://www.roblox.com/library/1234/..."
    --          "https://create.roblox.com/store/asset/1234/..."  "...?id=1234"
    local function parseAssetId(raw)
        if not raw then return "" end
        raw = raw:gsub("%s+", "")
        if raw == "" then return "" end
        -- Try common URL patterns first.
        local m = raw:match("[%?&]ID?=(%d+)")              -- ?id=12345
              or raw:match("/asset/?(%d+)")                 -- /asset/12345
              or raw:match("/library/(%d+)")                -- /library/12345
              or raw:match("/catalog/(%d+)")                -- /catalog/12345
              or raw:match("rbxassetid://(%d+)")            -- rbxassetid://12345
              or raw:match("(%d+)$")                        -- trailing digits
        return m or raw
    end
    local function loadManual()
        local id = parseAssetId(idBox.Text)
        if id == "" or not id:match("^%d+$") then
            if infoName then infoName.Text = "Bad asset ID" end
            return
        end
        if not logged[id] then
            logged[id] = { id = id,
                name = nameCache[id] or ("Anim " .. id),
                owner = "manual",
                cat = categorize(nameCache[id] or ""),
                lastSeen = os.clock() }
        end
        loadPreview(id); refreshList()
    end
    loadBtn.MouseButton1Click:Connect(loadManual)
    idBox.FocusLost:Connect(function(enter) if enter then loadManual() end end)

    local pauseBtn = mk("TextButton", { Size=UDim2.new(0,128,1,0), Position=UDim2.fromOffset(436,0),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Pause Loading",
        TextColor3=C.text, TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(pauseBtn,5)
    pauseBtn.MouseButton1Click:Connect(function()
        logPaused=not logPaused
        pauseBtn.Text = logPaused and "Resume Loading" or "Pause Loading"
        pauseBtn.BackgroundColor3 = logPaused and C.accent or C.row
        pauseBtn.TextColor3 = logPaused and Color3.new(1,1,1) or C.text
    end)
    -- Distance gate: only capture animations from owners within X studs.
    local RANGES = { 0, 50, 100, 200, 500, 1000 }   -- 0 = unlimited
    local function rangeText()
        local r = State and State.AnimVizRange or 0
        if r == 0 then return "Range: All" end
        return "Range: " .. r
    end
    local rangeBtn = mk("TextButton", { Size=UDim2.new(0,100,1,0), Position=UDim2.fromOffset(568,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text=rangeText(),
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(rangeBtn,5)
    rangeBtn.MouseButton1Click:Connect(function()
        local cur = State and State.AnimVizRange or 0
        local idx = 1
        for i, v in ipairs(RANGES) do if v == cur then idx = i break end end
        local nxt = RANGES[(idx % #RANGES) + 1]
        if State then State.AnimVizRange = nxt end
        Settings.set("state__AnimVizRange", nxt)
        rangeBtn.Text = rangeText()
    end)
    -- Clear button: wipes the captured animation list + recents (preserves
    -- favorites, blacklist and parry timings).
    local clearBtn = mk("TextButton", { Size=UDim2.new(0,72,1,0), Position=UDim2.fromOffset(672,0),
        BackgroundColor3=Color3.fromRGB(200,70,90), BorderSizePixel=0,
        Text="Clear", TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.GothamBold,
        Parent=row2 })
    corner(clearBtn,5)
    -- Two-step confirm so an accidental click doesn't wipe a long session.
    local pendingClear = false
    clearBtn.MouseButton1Click:Connect(function()
        if not pendingClear then
            pendingClear = true
            clearBtn.Text = "Confirm?"
            task.delay(2, function()
                if clearBtn.Parent and clearBtn.Text == "Confirm?" then
                    clearBtn.Text = "Clear"; pendingClear = false
                end
            end)
            return
        end
        pendingClear = false; clearBtn.Text = "Clear"
        logged = {}; recents = {}; entityCache = {}
        if clearPreview then clearPreview() end
        if AV._refreshRail then AV._refreshRail() end
        refreshList()
    end)
    local statusLbl = mk("TextLabel", { Size=UDim2.new(1,-752,1,0), Position=UDim2.fromOffset(748,0),
        BackgroundTransparency=1, Text="", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=row2 })
    AV._status = statusLbl

    -- ===== Body: 3 columns (category rail | animation list | preview) =====
    local body = mk("Frame", { Size=UDim2.new(1,-16,1,-110), Position=UDim2.fromOffset(8,102),
        BackgroundTransparency=1, Parent=win })

    -- COLUMN 1: category rail
    local rail = mk("Frame", { Size=UDim2.new(0,160,1,0), Position=UDim2.fromOffset(0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(rail,8)
    mk("TextLabel", { Size=UDim2.new(1,-12,0,20), Position=UDim2.fromOffset(10,6),
        BackgroundTransparency=1, Text="CATEGORIES", TextColor3=C.accent, TextSize=11,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=rail })
    local railScroll = mk("ScrollingFrame", { Size=UDim2.new(1,-8,1,-32), Position=UDim2.fromOffset(4,28),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3,
        CanvasSize=UDim2.new(0,0,0,0), Parent=rail })
    local railLayout = mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, railScroll)

    local railBtns = {}
    local FIXED = { {"⭐ Favorites","Favorites"}, {"🕒 Recent","Recent"}, {"📋 All","All"}, {"🚫 Blacklist","Blacklist"} }
    local function refreshRail(force)
        -- gather dynamic categories present in logged data
        local seen, dyn = {}, {}
        for _, e in pairs(logged) do
            local c = e.cat or "Other"
            if not seen[c] then seen[c] = true; table.insert(dyn, c) end
        end
        table.sort(dyn)
        -- signature guard: skip rebuild if categories + selection unchanged
        local sig = catFilter .. "|" .. table.concat(dyn, ",")
        if not force and sig == AV._railSig then return end
        AV._railSig = sig
        for _, c in ipairs(railScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        railBtns = {}
        local items = {}
        for _, f in ipairs(FIXED) do table.insert(items, f) end
        for _, c in ipairs(dyn) do table.insert(items, { c, c }) end
        for i, it in ipairs(items) do
            local label, key = it[1], it[2]
            local b = mk("TextButton", { Size=UDim2.new(1,-4,0,28),
                BackgroundColor3=(catFilter==key) and C.accent or C.row, BorderSizePixel=0,
                Text="  "..label, TextColor3=(catFilter==key) and Color3.new(1,1,1) or C.text,
                TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left,
                LayoutOrder=i, Parent=railScroll })
            corner(b,5)
            b.MouseButton1Click:Connect(function() catFilter=key; refreshRail(true); refreshList() end)
            railBtns[key]=b
        end
        railScroll.CanvasSize = UDim2.new(0,0,0,#items*31)
    end
    AV._refreshRail = refreshRail

    -- COLUMN 2: animation list
    local listPane = mk("Frame", { Size=UDim2.new(0.42,-4,1,0), Position=UDim2.fromOffset(168,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(listPane,8)
    listScroll = mk("ScrollingFrame", { Size=UDim2.new(1,-8,1,-8), Position=UDim2.fromOffset(4,4),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,0), Parent=listPane })
    listLayout = mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listScroll)

    -- COLUMN 3: preview / detail
    local rightPane = mk("Frame", { Size=UDim2.new(0.58,-164,1,0), Position=UDim2.new(0.42,172,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(rightPane,8)
    local detail = mk("Frame", { Size=UDim2.new(1,-12,1,-12), Position=UDim2.fromOffset(6,6),
        BackgroundTransparency=1, Parent=rightPane })
    local dLayout = mk("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, detail)

    -- 1) viewport
    viewport = mk("ViewportFrame", { Size=UDim2.new(1,0,0,460), BackgroundColor3=C.bg,
        BorderSizePixel=0, LayoutOrder=1, Parent=detail })
    corner(viewport,6)
    vpWM = mk("WorldModel", {}, viewport)
    vpCam = mk("Camera", { FieldOfView=60 }, viewport); viewport.CurrentCamera = vpCam

    -- 2) info name
    infoName = mk("TextLabel", { Size=UDim2.new(1,0,0,20), BackgroundTransparency=1,
        Text="Select an animation", TextColor3=C.text, TextSize=15, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=2, Parent=detail })
    -- 3) info id (with copy)
    local idRow = mk("Frame", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=3, Parent=detail })
    infoId = mk("TextLabel", { Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1,
        Text="—", TextColor3=C.accent, TextSize=12, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=idRow })
    local idCopy = mk("TextButton", { Size=UDim2.fromOffset(54,20), Position=UDim2.new(1,-54,0,1),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Copy ID", TextColor3=C.accent,
        TextSize=11, Font=Enum.Font.GothamBold, Parent=idRow })
    corner(idCopy,4)
    idCopy.MouseButton1Click:Connect(function()
        if not selectedId then return end
        local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if cb then pcall(cb, selectedId) end
        idCopy.Text="✓"; task.delay(0.5,function() if idCopy.Parent then idCopy.Text="Copy ID" end end)
    end)
    -- 4) meta line
    infoMeta = mk("TextLabel", { Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
        Text="", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=4, Parent=detail })

    -- 5) transport controls
    local ctrl = mk("Frame", { Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=5, Parent=detail })
    local function tbtn(x,w,txt,fn)
        local b=mk("TextButton",{Size=UDim2.new(0,w,1,0),Position=UDim2.fromOffset(x,0),
            BackgroundColor3=C.row,BorderSizePixel=0,Text=txt,TextColor3=C.text,
            TextSize=13,Font=Enum.Font.GothamBold,Parent=ctrl}); corner(b,5); b.MouseButton1Click:Connect(fn); return b
    end
    playBtn = tbtn(0,58,"Pause", function()
        if not currentTrack then return end
        paused = not paused
        currentTrack:AdjustSpeed(paused and 0 or playSpeed)
    end)
    playBtn.Name = "play"
    tbtn(62,64,"Restart", function()
        if currentTrack then currentTrack.TimePosition = 0 end
    end)
    -- retry button (hidden unless a load failed)
    local retryBtn = tbtn(128,58,"Retry", function()
        if AV._lastLoadId and AV._loadPreview then AV._loadPreview(AV._lastLoadId) end
    end)
    retryBtn.BackgroundColor3 = C.accent2; retryBtn.Visible = false; retryBtn.ZIndex = 5
    AV._retryBtn = retryBtn
    -- speed label + slider area
    local spdLbl = mk("TextLabel",{Size=UDim2.new(0,64,1,0),Position=UDim2.fromOffset(132,0),
        BackgroundTransparency=1,Text="Speed 1.0x",TextColor3=C.dim,TextSize=11,
        Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,Parent=ctrl})
    local spdBar = mk("Frame",{Size=UDim2.new(1,-204,0,6),Position=UDim2.fromOffset(200,11),
        BackgroundColor3=C.bg,BorderSizePixel=0,Parent=ctrl}); corner(spdBar,3)
    local spdFill = mk("Frame",{Size=UDim2.new((1.0-0.1)/(2.0-0.1),0,1,0),
        BackgroundColor3=C.accent,BorderSizePixel=0,Parent=spdBar}); corner(spdFill,3)
    do
        local dragging
        local function applySpd(x)
            local rel=math.clamp((x-spdBar.AbsolutePosition.X)/spdBar.AbsoluteSize.X,0,1)
            playSpeed = math.floor((0.1 + rel*(2.0-0.1))*10+0.5)/10
            spdLbl.Text = "Speed "..playSpeed.."x"
            spdFill.Size=UDim2.new(rel,0,1,0)
            if currentTrack and not paused then currentTrack:AdjustSpeed(playSpeed) end
        end
        spdBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; applySpd(i.Position.X) end end)
        Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applySpd(i.Position.X) end end))
    end

    -- 6) timeline scrubber (own row)
    local timeRow = mk("Frame", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, LayoutOrder=6, Parent=detail })
    scrubTime = mk("TextLabel",{Size=UDim2.new(1,0,0,12),BackgroundTransparency=1,
        Text="0 / 0 ms",TextColor3=C.dim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=timeRow})
    local scrubBar = mk("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.fromOffset(0,16),
        BackgroundColor3=C.bg,BorderSizePixel=0,Parent=timeRow}); corner(scrubBar,4)
    scrubFill = mk("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.accent,
        BorderSizePixel=0,Parent=scrubBar}); corner(scrubFill,4)
    do
        local dragging
        local function applyScrub(x)
            if not currentTrack then return end
            paused = true
            if playBtn then playBtn.Text = "Play" end
            currentTrack:AdjustSpeed(0)
            local rel=math.clamp((x-scrubBar.AbsolutePosition.X)/scrubBar.AbsoluteSize.X,0,1)
            currentTrack.TimePosition = rel * currentTrack.Length
            scrubFill.Size=UDim2.new(rel,0,1,0)
        end
        scrubBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; applyScrub(i.Position.X) end end)
        Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applyScrub(i.Position.X) end end))
    end

    -- 7) Save buttons (own rows, BELOW scrubber — no overlap).
    -- Parry timings ADD (you can save several frames per animation).
    saveBtn = mk("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=C.accent2,
        BorderSizePixel=0, Text="+ Add this frame as Parry Timing", TextColor3=Color3.fromRGB(255,255,255),
        TextSize=13, Font=Enum.Font.GothamBold, LayoutOrder=7, Parent=detail })
    corner(saveBtn,6)
    saveBtn.MouseButton1Click:Connect(function()
        if not currentTrack or not selectedId then return end
        local id, ts = selectedId, currentTrack.TimePosition
        local pt = _G.__ParryTimings
        local existing = (pt and pt.getTimes and pt.getTimes(id)) or {}
        local function doAddNew()
            promptCategory(id, ts, function(cat)
                if _G.__Notify then _G.__Notify("Parry Timing Added",
                    string.format("%s -> %s @ %dms",
                        (logged[id] and logged[id].name) or id, cat, math.floor(ts*1000)),
                    2.5, C.good) end
                if selectedId == id then loadPreview(id) end  -- refresh meta
            end, "parry")
        end
        if #existing > 0 then
            -- Ask: replace an existing timing, or add this as another?
            promptReplaceOrAdd(id, ts, existing,
                function() if selectedId == id then loadPreview(id) end end,  -- onChanged (replaced)
                doAddNew)                                                     -- onAdd (new)
        else
            doAddNew()
        end
    end)
    -- Dodge timing (separate list — AutoParry dodges instead of blocks here).
    local saveDodgeBtn = mk("TextButton", { Size=UDim2.new(1,0,0,30),
        BackgroundColor3=C.row, BorderSizePixel=0,
        Text="+ Add this frame as Dodge Timing", TextColor3=C.text,
        TextSize=13, Font=Enum.Font.GothamBold, LayoutOrder=8, Parent=detail })
    corner(saveDodgeBtn,6)
    saveDodgeBtn.MouseEnter:Connect(function() saveDodgeBtn.BackgroundColor3=C.hover end)
    saveDodgeBtn.MouseLeave:Connect(function() saveDodgeBtn.BackgroundColor3=C.row end)
    saveDodgeBtn.MouseButton1Click:Connect(function()
        if not currentTrack or not selectedId then return end
        local id, ts = selectedId, currentTrack.TimePosition
        local pt = _G.__ParryTimings
        local existing = (pt and pt.getDodges and pt.getDodges(id)) or {}
        local function doAddNew()
            promptCategory(id, ts, function(cat)
                if _G.__Notify then _G.__Notify("Dodge Timing Added",
                    string.format("%s -> %s @ %dms",
                        (logged[id] and logged[id].name) or id, cat, math.floor(ts*1000)),
                    2.5, C.good) end
                if selectedId == id then loadPreview(id) end
            end, "dodge")
        end
        if #existing > 0 then
            -- Replace an existing dodge timing, or add this as another.
            promptReplaceOrAdd(id, ts, existing,
                function() if selectedId == id then loadPreview(id) end end,  -- onChanged (replaced)
                doAddNew, "dodge")                                            -- onAdd (new)
        else
            doAddNew()
        end
    end)
    -- Per-attack PARRY RANGE (deepwoken imdd/imxd). Blank = use the global Detection
    -- Range. Combat reads _G.__ParryRanges[animId] = { min, max }.
    do
        local rr = mk("Frame", { Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=10, Parent=detail })
        mk("TextLabel", { Size=UDim2.fromOffset(110,28), BackgroundTransparency=1, Text="Parry range (studs)",
            TextColor3=C.dim, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, Parent=rr })
        local function box(x, ph)
            local b = mk("TextBox", { Size=UDim2.fromOffset(58,22), Position=UDim2.fromOffset(x,3),
                BackgroundColor3=C.bgAlt, BorderSizePixel=0, PlaceholderText=ph, Text="",
                TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
                ClearTextOnFocus=false, Parent=rr }); corner(b,5)
            mk("UIPadding", { PaddingLeft=UDim.new(0,6) }, b)
            return b
        end
        local minB = box(114, "min")
        mk("TextLabel", { Size=UDim2.fromOffset(14,28), Position=UDim2.fromOffset(176,0), BackgroundTransparency=1,
            Text="–", TextColor3=C.dim, TextSize=14, Font=Enum.Font.GothamBold, Parent=rr })
        local maxB = box(190, "max")
        local function apply()
            if not selectedId then return end
            local id = tostring(selectedId)
            local mn, mx = tonumber(minB.Text), tonumber(maxB.Text)
            _G.__ParryRanges = _G.__ParryRanges or {}
            if (not mn or mn <= 0) and (not mx or mx <= 0) then
                _G.__ParryRanges[id] = nil
            else
                _G.__ParryRanges[id] = { min = mn or 0, max = mx or 1000 }
            end
            Settings.set("parry_ranges", _G.__ParryRanges)
        end
        minB.FocusLost:Connect(apply); maxB.FocusLost:Connect(apply)
        local shown
        Conns.add(RunService.RenderStepped:Connect(function()
            if selectedId == shown then return end
            shown = selectedId
            local rng = selectedId and _G.__ParryRanges and _G.__ParryRanges[tostring(selectedId)]
            minB.Text = rng and tostring(rng.min) or ""
            maxB.Text = rng and tostring(rng.max) or ""
        end))
    end

    -- live scrubber/time update.
    -- ViewportFrame animations do NOT auto-advance, so we manually tick
    -- TimePosition each frame while playing — this is what makes the rig move.
    local lastPlayLabel, lastTimeText
    Conns.add(RunService.RenderStepped:Connect(function(dt)
        if not (gui and gui.Enabled and currentTrack) then return end
        local wantLabel = paused and "Play" or "Pause"
        if playBtn and lastPlayLabel ~= wantLabel then
            lastPlayLabel = wantLabel; playBtn.Text = wantLabel
        end
        local len = currentTrack.Length
        if len > 0 and not paused then
            local nt = currentTrack.TimePosition + dt * playSpeed
            if nt >= len then nt = nt % len end       -- loop
            currentTrack.TimePosition = nt             -- Animator poses the rig
        end
        local rel = (len > 0) and currentTrack.TimePosition/len or 0
        scrubFill.Size = UDim2.new(rel, 0, 1, 0)
        -- Time text only changes at ms granularity; skip identical writes.
        local timeText = string.format("%d / %d ms",
            math.floor(currentTrack.TimePosition*1000), math.floor(len*1000))
        if lastTimeText ~= timeText then lastTimeText = timeText; scrubTime.Text = timeText end
    end))

    -- ===== Hitbox Range (projectiles) — a detection MODE surfaced in the Visualizer =====
    -- Mirrors the Combat-tab controls; both read/write the SAME State, so changing
    -- one side changes the other. Floating panel, opened by the header "HBR" button.
    do
        local function persistHB(key, v) Settings.set("state__"..key, v) end
        local panel = mk("Frame", { Size=UDim2.fromOffset(304,384), AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(0.5,0,0.5,0), BackgroundColor3=C.bgAlt, BorderSizePixel=0,
            Visible=false, ZIndex=61, Parent=win })
        corner(panel,10); mk("UIStroke",{Color=C.border,Thickness=1,Transparency=0.15},panel)
        mk("TextLabel",{ Size=UDim2.new(1,-44,0,30), Position=UDim2.fromOffset(14,6),
            BackgroundTransparency=1, Text="🎯 Hitbox Range", TextColor3=C.text, TextSize=14,
            Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=62, Parent=panel })
        local pClose = mk("TextButton",{ Size=UDim2.fromOffset(24,22), Position=UDim2.new(1,-30,0,6),
            BackgroundColor3=C.row, BorderSizePixel=0, Text="×", TextColor3=C.text, TextSize=15,
            Font=Enum.Font.GothamBold, ZIndex=62, Parent=panel }); corner(pClose,4)
        pClose.MouseButton1Click:Connect(function() panel.Visible=false end)
        local bodyF = mk("ScrollingFrame",{ Size=UDim2.new(1,-18,1,-46), Position=UDim2.fromOffset(12,40),
            BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=C.accent2,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=62, Parent=panel })
        mk("UIListLayout",{ Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, bodyF)

        local paints, ord = {}, 0
        local function row(h) ord = ord + 1
            return mk("Frame",{ Size=UDim2.new(1,0,0,h), BackgroundTransparency=1, LayoutOrder=ord, ZIndex=62, Parent=bodyF })
        end
        local function hbToggle(labelTxt, get, set)
            local r = row(28)
            mk("TextLabel",{ Size=UDim2.new(1,-52,1,0), BackgroundTransparency=1, Text=labelTxt,
                TextColor3=C.text, TextSize=12, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=62, Parent=r })
            local pill = mk("TextButton",{ Size=UDim2.fromOffset(44,20), Position=UDim2.new(1,-44,0.5,-10),
                BackgroundColor3=C.row, BorderSizePixel=0, Text="", AutoButtonColor=false, ZIndex=62, Parent=r }); corner(pill,10)
            local knob = mk("Frame",{ Size=UDim2.fromOffset(16,16), Position=UDim2.fromOffset(2,2),
                BackgroundColor3=C.text, BorderSizePixel=0, ZIndex=62, Parent=pill }); corner(knob,8)
            local function paint() local on=get()
                pill.BackgroundColor3 = on and C.accent or C.row
                knob.Position = UDim2.fromOffset(on and 26 or 2, 2) end
            pill.MouseButton1Click:Connect(function() set(not get()); paint() end)
            paints[#paints+1]=paint; paint()
        end
        local function hbSlider(labelTxt, mn, mx, get, set, suffix)
            local r = row(42)
            local lbl = mk("TextLabel",{ Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Text=labelTxt,
                TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=62, Parent=r })
            local bar = mk("Frame",{ Size=UDim2.new(1,0,0,8), Position=UDim2.fromOffset(0,24),
                BackgroundColor3=C.bg, BorderSizePixel=0, ZIndex=62, Parent=r }); corner(bar,4)
            local fill = mk("Frame",{ Size=UDim2.new(0,0,1,0), BackgroundColor3=C.accent,
                BorderSizePixel=0, ZIndex=62, Parent=bar }); corner(fill,4)
            local function paint() local v=get()
                local rel=math.clamp((v-mn)/math.max(mx-mn,1),0,1); fill.Size=UDim2.new(rel,0,1,0)
                lbl.Text=labelTxt.."  "..tostring(v)..(suffix or "") end
            local dragging
            local function apply(x)
                local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
                set(math.floor(mn+rel*(mx-mn)+0.5)); paint() end
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; apply(i.Position.X) end end)
            Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
            Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then apply(i.Position.X) end end))
            paints[#paints+1]=paint; paint()
        end

        hbToggle("Hitbox Range Mode", function() return State.HitboxRangeMode end, function(v)
            if _G.__SetHitboxRangeMode then _G.__SetHitboxRangeMode(v) else State.HitboxRangeMode=v end
            persistHB("HitboxRangeMode", v) end)
        hbToggle("Parry on Entry", function() return State.HitboxRangeParry end, function(v)
            State.HitboxRangeParry=v; persistHB("HitboxRangeParry", v) end)
        hbSlider("Parry Range", 5, 80, function() return State.HitboxParryRange or 25 end, function(v)
            State.HitboxParryRange=v; persistHB("HitboxParryRange", v) end, " studs")
        hbSlider("Parry Delay", 0, 300, function() return math.floor((State.HitboxParryDelay or 0)*1000) end, function(v)
            State.HitboxParryDelay=v/1000; persistHB("HitboxParryDelay", State.HitboxParryDelay) end, " ms")
        hbToggle("Dodge on Entry", function() return State.HitboxRangeDodge end, function(v)
            State.HitboxRangeDodge=v; persistHB("HitboxRangeDodge", v) end)
        hbSlider("Dodge Range", 5, 80, function() return State.HitboxDodgeRange or 25 end, function(v)
            State.HitboxDodgeRange=v; persistHB("HitboxDodgeRange", v) end, " studs")
        hbSlider("Dodge Delay", 0, 300, function() return math.floor((State.HitboxDodgeDelay or 0)*1000) end, function(v)
            State.HitboxDodgeDelay=v/1000; persistHB("HitboxDodgeDelay", State.HitboxDodgeDelay) end, " ms")

        local hintR = row(34)
        mk("TextLabel",{ Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="Reacts to incoming projectiles by RANGE, independent of animation timing. Mirrors the Combat tab.",
            TextColor3=C.dim, TextSize=10, Font=Enum.Font.Gotham, TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=62, Parent=hintR })

        -- Header button that opens/closes the panel (re-syncs the controls on open).
        local hbBtn = mk("TextButton",{ Size=UDim2.fromOffset(38,22), Position=UDim2.new(1,-74,0,6),
            BackgroundColor3=C.row, BorderSizePixel=0, Text="HBR", TextColor3=C.accent, TextSize=11,
            Font=Enum.Font.GothamBold, Parent=header }); corner(hbBtn,4)
        hbBtn.MouseButton1Click:Connect(function()
            panel.Visible = not panel.Visible
            if panel.Visible then for _,p in ipairs(paints) do p() end end
        end)
    end

    refreshRail(true)
    refreshList()
end

----------------------------------------------------------------------
-- PUBLIC
----------------------------------------------------------------------
function AV.toggle(v)
    State.AnimViz = v
    MouseUnlock.setSource("anim", v)
    if v then
        if not gui then build() end
        gui.Enabled = true; AV._open = true; win.Visible = true
        refreshList()
    else
        AV._open = false
        if gui then gui.Enabled = false end
    end
end

function AV.openWithId(id)
    AV.toggle(true)
    id = tostring(id):gsub("rbxassetid://", "")
    -- ensure it's in the log even if never seen
    if not logged[id] then
        logged[id] = { id=id, name=nameCache[id] or ("Anim "..id), owner="?",
            cat=categorize(nameCache[id] or ""), lastSeen=os.clock() }
    end
    loadPreview(id); refreshList()
end

function AV.init(state)
    State = state
    Conns.onTeardown(function()
        if gui then pcall(function() gui:Destroy() end) end
        gui=nil; win=nil; currentTrack=nil
    end)
end

return AV

end)
__bundle_register("Utility/Humanoids", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Shared humanoid registry. Maintained once via DescendantAdded/Removing so
-- features (ESP, AutoParry, AnimVisualizer) never have to walk
-- workspace:GetDescendants() on a timer — the single biggest perf win.
local Conns = require("Utility/Conns")

local Humanoids = {}
local set = {}            -- humanoid -> true
local addedCbs = {}       -- callbacks(hum) for new humanoids

local function add(h)
    if set[h] then return end
    set[h] = true
    for _, cb in ipairs(addedCbs) do pcall(cb, h) end
end

for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("Humanoid") then add(d) end
end
Conns.add(workspace.DescendantAdded:Connect(function(o)
    if o:IsA("Humanoid") then add(o) end
end))
Conns.add(workspace.DescendantRemoving:Connect(function(o)
    if o:IsA("Humanoid") then set[o] = nil end
end))

-- Self-healing rescan: events can miss humanoids in games with streaming or
-- odd load order. Every 1.5s we sweep workspace to add any we missed and drop
-- dead refs. Cheap (runs at <1 Hz) and guarantees ESP/AutoParry see everyone.
local RunService = game:GetService("RunService")
do
    local lastPrune, lastScan = 0, 0
    Conns.add(RunService.Heartbeat:Connect(function()
        local now = tick()
        -- Cheap: drop dead refs (small set) every couple seconds.
        if now - lastPrune >= 2 then
            lastPrune = now
            for h in pairs(set) do
                if not h.Parent then set[h] = nil end
            end
        end
        -- Expensive: a full workspace:GetDescendants() allocates a 30k+ table
        -- and was running every 1.5s (constant GC churn / stutter). DescendantAdded
        -- already catches every new Humanoid, so this rescan is only a safety net
        -- for streaming/odd load order — run it rarely.
        if now - lastScan >= 10 then
            lastScan = now
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Humanoid") and not set[d] then add(d) end
            end
        end
    end))
end

-- Iterate current humanoids: for hum in Humanoids.iter() do ... end
function Humanoids.iter() return pairs(set) end
function Humanoids.set() return set end
-- Register a callback fired for every humanoid (existing + future).
function Humanoids.onAdded(cb)
    for h in pairs(set) do pcall(cb, h) end
    table.insert(addedCbs, cb)
end

return Humanoids

end)
__bundle_register("Features/ModeratorChecker", function(require, _LOADED, __bundle_register, __bundle_modules)
-- ModeratorChecker: scans the server for known game moderators / admins, and
-- (separately) known content creators / YouTubers.
--
-- Moderator detection sources (any one triggers):
--   * Username on the built-in DEFAULT_MODS list, or getgenv().ModeratorList
--   * Player has a "Mod" / "Admin" / "Developer" tag attribute set
--   * Player's leaderstats contains "Admin" / "Moderator"
-- YouTuber detection:
--   * Username on the built-in DEFAULT_YOUTUBERS list, or getgenv().YouTuberList
local Players      = game:GetService("Players")
local Conns        = require("Utility/Conns")
local Notification = require("Features/Notification")

local ModeratorChecker = {}
local State

-- Known moderators (Roblox usernames, lowercase, de-duplicated).
local DEFAULT_MODS = {
    "3kazo","greathorne1","marrsworid","bufordith","crazywealth","songofancient",
    "koveszn","killer67564564643","emrahdior","ashapira","kyutality","den4ick100",
    "zdissy","rareredbutterflies","nixhwa","kenanqk","taisabu_il","plamitic",
    "briancf1","bonbabrtime","iale11","nicolasmm12","mkmosc","ragingsama",
    "imtonindo","arthemist","lazarovip2","externaltv_man","utility5452",
    "frankxlin17","qasward","colossalturtle",
}

-- Known content creators / YouTubers (Roblox usernames, lowercase).
local DEFAULT_YOUTUBERS = {
    "ivtwig","hauntedrecalling","vasmery","crimsonmoonxiii","hollowed_requiem",
    "kingnogo","realryujiyt","inczsss","fake_borgor","zsayfu","foururex",
    "raizer_albertiks","sifanprayer","zentubaa","xxabsolutoxx","yoimaginetho",
    "yourenotben","mizurri","123monkeydluffy","ashtek01","whenwemustpart",
    "rayva1y","stumble99999999999","luffy_08363","life9s","nellyumi","10josse75",
    "banzigotop","pikayo_yt","soggy_turkeyflaps","47dere","ponpungo","jariius",
    "zigzagfangamer","dopestar210","snotzakdoekjes","bronyman013","sa1tyt",
    "mightfreedy","ghostzbunny","marvyflex","lnsignius","desiredc0des",
    "iisciencecow","gggameslytl","nanoprodigy","notgcool360","iiverm",
    "eternalsurgeheim","chawyjr","drizzyontopp","saintethan","justkenshiiii",
    "shinou40","rozzande","follow_aa1nt","rayquazas2828","imjustalpha1","xxarpcc",
    "jadendragon87690","o0f5s","lastword_mutt","2veloyt","peep3w","ttsuciohh",
    "exvar","boipsuu","yileenas","clxud9z","carcerality","whoelsebutbaggy",
    "hw5567","qwerghuiles","dumboyyyy","rusticblackops01","ygsnipaa",
    "uzumakipedriin","sap906","mrcaptkiddjr","shewantshermes","guizeratrue",
    "w3_s7","casualcause","d9ubt","superzydan","sagez_szg","baderasaurus",
    "af1errain","legroupleader","ezzotik","fadedlanded","cxrsedhakii","5rz4",
    "itsmumed","universalpanthers","planetcea17","yelixo","mk47ss","spikey_28",
    "jimmy_bnks","zperqs","jamaldingel","c1isontop","nwarplay","adm_5778c",
    "builderboy100009","ashysrr","midnytejay","sly_kage","yezxfxz","syoct",
    "az1nu","sweepeerblx","cuongbots","breazsy","convictvince","thebigtanjiroo",
    "davonnydripy","trop555","adriano_thebos","fentfein38","itsosskar","unotwoyt",
    "newbami1","supremexxape_games","sagee4","truth_rain","holvenom",
    "slyalphagronk","reaconteur_real","maxgonebed","yunuskakas","dannyplayz80",
    "tariqrbx_1","waludy_yt","jayyment","deadpoolj81","supercoolrami214",
    "bundlelf5","m1xm55","bohemianfart","kj_gmr2","jeffrlgamer","zombieylol",
    "whoisnikkx","leisurement","zentiiyt","nrh_cam","notraf_dev","aceyywayce",
    "bushidof3","nanerki","svkqqqq","exotcixz","fexler","imshredsy","xseweffect",
    "remkaioh","godden3","0mervons","forgetkas","jagritifrance","ffangoat",
    "1b0di","skyintriga","hey_carnival","qbe100","corgivr_yt","spidaboy1",
    "potatoswagcrea","batslc","kaiserflowss","ghostinthecosmosv2","yourprogenltor",
    "realwicky","ixoy","smallliuyt","lotus0yt","llvoidzz","j4y2e",
    "ghostinthecosmos","bugzbylee","s_supaa","therealpunchee","agamatsu",
    "ttvsmilezt_t","uncleyogu","jp55123","stayglide","imbenni","madecalm",
    "felineemu","xlayoox","pokeyyyxd","valekisyt","terrabl0x","mojayxy",
    "necaelum","bizarrelies","ltzakuu","lts_nin","hatetana","neckolauu","rvsaix",
    "najiswrldd","d_mlno","captinttbyt","revolverragz",
}

-- O(1) lookup sets.
local MOD_SET, YT_SET = {}, {}
for _, n in ipairs(DEFAULT_MODS)      do MOD_SET[n] = true end
for _, n in ipairs(DEFAULT_YOUTUBERS) do YT_SET[n]  = true end

-- Returns a reason string if `player` is a moderator, else nil.
local function isModerator(player)
    local nm = player.Name:lower()
    local list = getgenv().ModeratorList
    if type(list) == "table" then
        for _, n in ipairs(list) do
            if nm == tostring(n):lower() then return "Custom list" end
        end
    end
    if MOD_SET[nm] then return "Known moderator" end
    for _, k in ipairs({ "Mod","Moderator","Admin","Developer","Staff" }) do
        if player:GetAttribute(k) then return "Attribute: " .. k end
    end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, v in ipairs(ls:GetChildren()) do
            local n = v.Name:lower()
            if n:find("admin") or n:find("mod") or n:find("staff") then
                return "Leaderstats: " .. v.Name
            end
        end
    end
    return nil
end

-- Returns a reason string if `player` is a known YouTuber, else nil.
local function isYouTuber(player)
    local nm = player.Name:lower()
    local list = getgenv().YouTuberList
    if type(list) == "table" then
        for _, n in ipairs(list) do
            if nm == tostring(n):lower() then return "Custom list" end
        end
    end
    if YT_SET[nm] then return "Known YouTuber" end
    return nil
end

-- Detect + notify one player as a moderator. Returns true if matched.
local function flag(player)
    if player == Players.LocalPlayer then return false end
    local reason = isModerator(player)
    if reason then
        Notification.send("⚠ Moderator: " .. player.Name,
            "Reason: " .. reason, 8, Color3.fromRGB(255, 90, 90), "Safety")
        return true
    end
    return false
end
-- Detect + notify one player as a YouTuber. Returns true if matched.
local function flagYT(player)
    if player == Players.LocalPlayer then return false end
    local reason = isYouTuber(player)
    if reason then
        Notification.send("📹 YouTuber: " .. player.Name,
            "Reason: " .. reason, 8, Color3.fromRGB(120, 170, 255), "Safety")
        return true
    end
    return false
end

-- Gated auto-hook: flag joiners against whichever checks are enabled.
local function onJoin(player)
    if State and State.ModeratorChecker then flag(player) end
    if State and State.YouTuberChecker then flagYT(player) end
end

-- Scan every current player and report results (runs regardless of the toggles,
-- so the "Scan players now" button always gives feedback).
function ModeratorChecker.scanAll()
    local mods, yts = 0, 0
    for _, p in ipairs(Players:GetPlayers()) do
        if flag(p)   then mods = mods + 1 end
        if flagYT(p) then yts  = yts  + 1 end
    end
    if mods == 0 and yts == 0 then
        Notification.send("Server Scan", "No moderators or YouTubers found.",
            4, Color3.fromRGB(120, 200, 150), "Safety")
    else
        Notification.send("Server Scan",
            ("%d moderator(s), %d YouTuber(s) found."):format(mods, yts),
            4, Color3.fromRGB(120, 200, 150), "Safety")
    end
end

function ModeratorChecker.setEnabled(v)
    State.ModeratorChecker = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do flag(p) end
    end
end
function ModeratorChecker.setYouTuberEnabled(v)
    State.YouTuberChecker = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do flagYT(p) end
    end
end

function ModeratorChecker.init(state)
    State = state
    Conns.add(Players.PlayerAdded:Connect(onJoin))
    task.delay(1, function()
        for _, p in ipairs(Players:GetPlayers()) do onJoin(p) end
    end)
end

return ModeratorChecker

end)
__bundle_register("Features/Notification", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Notification: stackable corner toasts.
-- Other features call:  Notification.send(title, message, duration, color)
local Players  = game:GetService("Players")
local TweenSvc = game:GetService("TweenService")
local LP       = Players.LocalPlayer
local Conns    = require("Utility/Conns")

local Notification = {}
local State

local screen
local active = {}     -- ordered list of frames currently visible
local SPACING = 8

local function repackage()
    local y = 16
    for _, n in ipairs(active) do
        n.frame:TweenPosition(UDim2.new(1, -16, 0, y),
            Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        y = y + n.frame.AbsoluteSize.Y + SPACING
    end
end

-- Notification categories -> the State flag that enables them (default on). A
-- notification tagged with a category is suppressed when its flag is false.
local CAT_KEY = { Toggle = "NotifToggles", Safety = "NotifSafety" }
function Notification.send(title, message, duration, color, category)
    if not State or not State.NotificationsEnabled then return end
    if category then local k = CAT_KEY[category]; if k and State[k] == false then return end end
    if not screen then return end
    duration = duration or 3
    color    = color    or Color3.fromRGB(96, 175, 255)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 56)
    frame.Position = UDim2.new(1, 16, 0, 16)      -- start off-screen right
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    frame.BorderSizePixel = 0
    frame.Parent = screen

    local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0, 6)
    local stripe = Instance.new("Frame", frame)
    stripe.Size = UDim2.new(0, 4, 1, 0); stripe.BackgroundColor3 = color
    stripe.BorderSizePixel = 0
    local sc = Instance.new("UICorner", stripe); sc.CornerRadius = UDim.new(0, 4)

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(1, -16, 0, 18); t.Position = UDim2.new(0, 12, 0, 6)
    t.BackgroundTransparency = 1; t.Text = title or ""
    t.TextColor3 = Color3.fromRGB(240, 240, 245)
    t.TextSize = 14; t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTruncate = Enum.TextTruncate.AtEnd

    local m = Instance.new("TextLabel", frame)
    m.Size = UDim2.new(1, -16, 0, 24); m.Position = UDim2.new(0, 12, 0, 24)
    m.BackgroundTransparency = 1; m.Text = message or ""
    m.TextColor3 = Color3.fromRGB(190, 195, 210)
    m.TextSize = 12; m.Font = Enum.Font.Gotham
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.TextWrapped = true

    local entry = { frame = frame }
    table.insert(active, 1, entry)
    repackage()

    task.delay(duration, function()
        if not frame.Parent then return end
        TweenSvc:Create(frame, TweenInfo.new(0.2),
            { Position = UDim2.new(1, 16, frame.Position.Y.Scale, frame.Position.Y.Offset) }):Play()
        task.wait(0.22)
        if frame.Parent then frame:Destroy() end
        for i, e in ipairs(active) do
            if e == entry then table.remove(active, i); break end
        end
        repackage()
    end)
end

function Notification.setParent(p)
    if screen then pcall(function() screen:Destroy() end) end
    screen = Instance.new("ScreenGui")
    screen.Name = "Notifications"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 1000
    screen.IgnoreGuiInset = true
    screen.Parent = p
end

function Notification.init(state)
    State = state
    Conns.onTeardown(function()
        if screen then pcall(function() screen:Destroy() end) end
        active = {}; screen = nil
    end)
end

return Notification

end)
__bundle_register("Features/Debug", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Debug: on-screen diagnostic panel.
-- Shows FPS, ping, memory, active feature flags, and latest AutoParry result.
local RS       = game:GetService("RunService")
local Stats    = game:GetService("Stats")
local LP       = game:GetService("Players").LocalPlayer
local Conns    = require("Utility/Conns")

local Debug = {}
local State, panel, lines, parent, debugGui

local function build()
    if not parent then return end   -- wait until the menu has set our parent
    -- A raw Frame parented to PlayerGui does NOT render — it needs a ScreenGui.
    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "VVDebug"; debugGui.ResetOnSpawn = false
    debugGui.IgnoreGuiInset = true; debugGui.DisplayOrder = 999; debugGui.Parent = parent
    panel = Instance.new("Frame")
    panel.Name = "DebugPanel"
    panel.Size = UDim2.new(0, 240, 0, 160)
    panel.Position = UDim2.new(1, -260, 0, 60)
    panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.BackgroundTransparency = 0.4
    panel.BorderSizePixel = 0
    panel.Parent = debugGui
    local c = Instance.new("UICorner", panel); c.CornerRadius = UDim.new(0, 4)

    lines = {}
    local list = Instance.new("UIListLayout", panel)
    list.Padding = UDim.new(0, 2); list.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", panel)
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)

    for i = 1, 8 do
        local l = Instance.new("TextLabel", panel)
        l.LayoutOrder = i; l.Size = UDim2.new(1, 0, 0, 16)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(120, 255, 120)
        l.TextSize = 12; l.Font = Enum.Font.Code
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = ""
        lines[i] = l
    end
end

local function destroy()
    if debugGui then pcall(function() debugGui:Destroy() end) end
    debugGui = nil; panel = nil; lines = nil
end

local frames, t0 = 0, tick()
local fps, lastDraw = 0, 0
local function tick_loop()
    frames = frames + 1
    local now = tick()
    if now - t0 >= 0.5 then fps = frames / (now - t0); frames = 0; t0 = now end
    if not State or not State.Debug then return end
    if not panel then build() end
    -- Only redraw the panel text twice a second (was every frame).
    if now - lastDraw < 0.5 then return end
    lastDraw = now
    local ping = 0; pcall(function() ping = LP:GetNetworkPing() * 2000 end)  -- ms RTT
    local mem  = math.floor((collectgarbage("count") or 0) / 1024)
    lines[1].Text = ("FPS: %.0f"):format(fps)
    lines[2].Text = ("Ping: %.0f ms"):format(ping)
    lines[3].Text = ("Lua Mem: %d MB"):format(mem)
    lines[4].Text = "—"
    lines[5].Text = ("AutoParry: %s"):format(State.AutoParry and "ON" or "off")
    lines[6].Text = ("Sprint:   %s"):format(State.ToggleSprint and "ON" or "off")
    lines[7].Text = ("Fly: %s | Noclip: %s"):format(
        State.Fly and "ON" or "off", State.Noclip and "ON" or "off")
    lines[8].Text = (_G.__lastParry and ("Last parry: " .. _G.__lastParry))
                    or "Last parry: —"
end

function Debug.setDebug(v)
    State.Debug = v
    if not v then destroy() end
end

function Debug.setParent(p) parent = p end
function Debug.init(state)
    State = state
    Conns.add(RS.Heartbeat:Connect(tick_loop))
    Conns.onTeardown(destroy)
end

return Debug

end)
__bundle_register("Features/RemoteSpy", function(require, _LOADED, __bundle_register, __bundle_modules)
-- RemoteSpy ("Spyware"): logs RemoteEvent / RemoteFunction traffic so you can
-- see exactly what your client fires (and optionally what the server fires at
-- you). This is the same technique that captured the parry remote
--   ReplicatedStorage.Requests.Combat:FireServer("Block", true)
-- used by Features/Combat.
--
-- Two capture directions:
--   * "out" (Self)    — FireServer / InvokeServer your client sends. Caught via
--                       a single __namecall hook (installed once, _G-guarded so
--                       a Restart never stacks a second hook).
--   * "in"  (Enemies) — OnClientEvent the server fires at you. Caught by
--                       connecting to every RemoteEvent under ReplicatedStorage.
--
-- The UI lives in Menu/Main (Misc → Spyware). This module only owns the hooks,
-- the log, and the pause/clear/filter state.
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Conns   = require("Utility/Conns")

local RemoteSpy = {}
local State

local MAX_ENTRIES = 250        -- ring buffer cap (oldest dropped past this)

local log     = {}             -- ordered array of entries (oldest first)
local byKey   = {}             -- "dir\1path\1method" -> entry (dedup/aggregate)
local updateCb                 -- optional UI refresh callback
local version = 0              -- bumped on any change; UI polls this

-- Incoming (OnClientEvent) listeners, kept so we can detach on disable.
local incomingConns  = {}      -- remote -> RBXScriptConnection
local incomingScan             -- DescendantAdded watcher

-- Executor capability check. Without these, outgoing capture is impossible.
local hasHook = (type(hookmetamethod) == "function")
    and (type(getnamecallmethod) == "function")

local function notify(...) if _G.__Notify then _G.__Notify(...) end end

--========================================================
-- Serialization (safe, bounded — never let a weird arg error the hook).
--========================================================
local function fullName(inst)
    local ok, n = pcall(function() return inst:GetFullName() end)
    if ok and n then return n end
    return tostring(inst)
end

local function short(s, n)
    n = n or 60; s = tostring(s)
    if #s > n then return s:sub(1, n) .. "…" end
    return s
end

local function ser(v, depth)
    depth = depth or 0
    local t = typeof(v)
    if t == "Instance" then return fullName(v)
    elseif t == "string" then return '"' .. short(v) .. '"'
    elseif t == "number" or t == "boolean" then return tostring(v)
    elseif t == "nil" then return "nil"
    elseif t == "Vector3" then return ("Vector3(%.1f, %.1f, %.1f)"):format(v.X, v.Y, v.Z)
    elseif t == "CFrame" then local p = v.Position
        return ("CFrame(%.1f, %.1f, %.1f)"):format(p.X, p.Y, p.Z)
    elseif t == "table" then
        if depth >= 2 then return "{...}" end
        local parts, i = {}, 0
        for k, val in pairs(v) do
            i = i + 1; if i > 6 then parts[#parts + 1] = "…"; break end
            parts[#parts + 1] = tostring(k) .. "=" .. ser(val, depth + 1)
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else return t end
end

local function argstr(args, n)
    local parts = {}
    for i = 1, n do parts[i] = ser(args[i]) end
    return table.concat(parts, ", ")
end

--========================================================
-- Log recording.
--========================================================
-- Capturing is live only when the master switch is on and not paused.
local function active() return State and State.Spyware and not State.SpyPaused end

local function record(dir, remote, method, args, n)
    if not remote then return end
    local path = fullName(remote)
    local key  = dir .. "\1" .. path .. "\1" .. method
    local e = byKey[key]
    if not e then
        e = { key = key, remote = remote, name = remote.Name, path = path,
              class = remote.ClassName, dir = dir, method = method, count = 0 }
        byKey[key] = e
        table.insert(log, e)
        if #log > MAX_ENTRIES then
            local rm = table.remove(log, 1)
            if rm then byKey[rm.key] = nil end
        end
    end
    e.count    = e.count + 1
    e.lastArgs = argstr(args, n)
    e.lastTime = os.clock()
    version = version + 1
    if updateCb then pcall(updateCb) end
end

--========================================================
-- Outgoing capture: ONE __namecall hook, installed once per executor session.
-- The actual recording goes through _G.__VVSpyRecord, swapped each run, so a
-- Restart updates behaviour without ever stacking a second metamethod hook.
--========================================================
_G.__VVSpyRecord = function(self, ...)
    if not (active() and State.SpySelf) then return end
    if typeof(self) ~= "Instance" then return end
    local method = getnamecallmethod()
    if method ~= "FireServer" and method ~= "InvokeServer" then return end
    local cls = self.ClassName
    if cls == "RemoteEvent" or cls == "RemoteFunction"
        or cls == "UnreliableRemoteEvent" then
        record("out", self, method, { ... }, select("#", ...))
    end
end

local function installHook()
    if not hasHook or _G.__VVSpyInstalled then return end
    _G.__VVSpyInstalled = true
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local cb = _G.__VVSpyRecord
        if cb then pcall(cb, self, ...) end   -- pcall: a logging error must never break the game
        return old(self, ...)
    end)
end

--========================================================
-- Incoming capture: connect OnClientEvent on every RemoteEvent in
-- ReplicatedStorage (where this game keeps its Requests). Only the gate
-- State.SpyEnemies decides whether the callback actually records.
--========================================================
local function attachIncoming(remote)
    if incomingConns[remote] then return end
    if remote.ClassName == "RemoteEvent" or remote.ClassName == "UnreliableRemoteEvent" then
        local c = remote.OnClientEvent:Connect(function(...)
            if active() and State.SpyEnemies then
                record("in", remote, "OnClientEvent", { ... }, select("#", ...))
            end
        end)
        incomingConns[remote] = c
        Conns.add(c)
    end
end

local function startIncoming()
    if incomingScan then return end
    for _, d in ipairs(RS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then attachIncoming(d) end
    end
    incomingScan = RS.DescendantAdded:Connect(function(d)
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then attachIncoming(d) end
    end)
    Conns.add(incomingScan)
end

local function stopIncoming()
    for _, c in pairs(incomingConns) do pcall(function() c:Disconnect() end) end
    incomingConns = {}
    if incomingScan then pcall(function() incomingScan:Disconnect() end); incomingScan = nil end
end

--========================================================
-- Public API.
--========================================================
function RemoteSpy.setEnabled(v)
    State.Spyware = v
    if v then
        if not hasHook then
            notify("Spyware", "This executor has no hookmetamethod — outgoing capture unavailable.",
                4, Color3.fromRGB(245, 100, 110))
        else
            installHook()
        end
        if State.SpyEnemies then startIncoming() end
    else
        stopIncoming()
    end
end

function RemoteSpy.setPaused(v) State.SpyPaused = v end
function RemoteSpy.setSelf(v)   State.SpySelf   = v end

function RemoteSpy.setEnemies(v)
    State.SpyEnemies = v
    if v then
        if State.Spyware then startIncoming() end
    else
        stopIncoming()
    end
end

function RemoteSpy.clear()
    log = {}; byKey = {}; version = version + 1
    if updateCb then pcall(updateCb) end
end

function RemoteSpy.getLog()      return log end
function RemoteSpy.getVersion()  return version end
function RemoteSpy.onUpdate(fn)  updateCb = fn end
function RemoteSpy.supported()   return hasHook end

function RemoteSpy.init(state)
    State = state
    -- A persisted-on state is re-applied from Menu/Main after Settings restore,
    -- so we don't enable here (State isn't restored yet at init time).
end

return RemoteSpy

end)
__bundle_register("Features/Combat", function(require, _LOADED, __bundle_register, __bundle_modules)
-- AutoParry — minimal core (mirrors the deepwoken / type-soul reference model):
--   * Hook every enemy Humanoid's AnimationPlayed.
--   * If the animation id has a saved timing (parrytimings.json — YOUR timings),
--     watch the track's TimePosition and press M2 exactly at that frame.
--   * Ping-compensated and AdjustSpeed-proof (lead scales with track.Speed).
--
-- Filters (the only options): Range, Nearest Target Only, Players Only,
-- Parry While Tabbed Out. Nothing else.
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local UIS        = game:GetService("UserInputService")
local VIM        = game:GetService("VirtualInputManager")
local RS         = game:GetService("ReplicatedStorage")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")
local Humanoids    = require("Utility/Humanoids")
local Notification = require("Features/Notification")
local Settings     = require("Utility/Settings")
local Latency      = require("Utility/Latency")   -- ping lead (so parries LAND on time)

local Combat = {}
local State

local pending = {}              -- track -> { animId, char, events={ {at,fired} } }
_G.__AutoParryActive = pending

local DEBOUNCE   = 0.10         -- min seconds between two presses (anti double-fire)
local HITSTUN    = 0.25         -- ignore window right after taking damage
local HOLD       = 0.02         -- M2 tap length (input-sim fallback only)
local lastFire, hitstunUntil = 0, 0
-- For repeat-on-miss: remember the most recent parry attempt.
local lastParry = { track = nil, t = 0, count = 0 }
-- Shared by BOTH reaction systems (animation-timing + Hitbox Range) so they
-- never double-fire a block/dodge for the same incoming hit.
local lastReactT = 0
local REACT_CD   = 0.15         -- min seconds between cross-system reactions

--========================================================
-- Input / Block
--
-- VV Ultimatum performs a block by firing ONE remote with a string action:
--   ReplicatedStorage.Requests.Combat:FireServer("Block", true)   -- start
--   ReplicatedStorage.Requests.Combat:FireServer("Block", false)  -- release
-- (captured live via a __namecall spy). We fire that remote directly, exactly
-- like the deepwoken reference fires its own Block remote — so it is
-- REBIND-PROOF: it works no matter what key the player has block bound to.
--========================================================

-- Cached remote lookup (re-resolves if the instance is replaced).
local _combatRemote
local function combatRemote()
    if _combatRemote and _combatRemote.Parent then return _combatRemote end
    local req = RS:FindFirstChild("Requests")
    _combatRemote = req and req:FindFirstChild("Combat") or nil
    return _combatRemote
end

-- Input-simulation fallback (only used if the remote can't be found).
local function pressM2Fallback()
    if mouse2press and mouse2release then
        pcall(function() mouse2press(); task.wait(HOLD); mouse2release() end); return
    end
    pcall(function()
        local m = LP:GetMouse()
        local x, y = m.X or 0, m.Y or 0
        VIM:SendMouseButtonEvent(x, y, 1, true, game, 0)
        task.delay(HOLD, function()
            pcall(function() VIM:SendMouseButtonEvent(x, y, 1, false, game, 0) end)
        end)
    end)
end

-- Fire the game's block: start, hold, release. The hold must be long enough to
-- still be active when the hit lands (the hit arrives ~150-240ms after we fire
-- at typical ping; a 150ms hold released too early and we ate the hit).
local function fireBlock()
    local r = combatRemote()
    if not r then pressM2Fallback(); return end
    _G.__VVBlockFired = os.clock()      -- mark: this block is OURS (Player Timing skips it)
    pcall(function() r:FireServer("Block", true) end)
    -- High Ping Mode: hold the block longer (by ~your round-trip ping) so it's
    -- still active when a jittery high-ping hit actually lands.
    local hold = State.BlockHold or 0.35
    if State.HighPing then hold = hold + (Latency.rtt() or 0) end
    task.delay(hold, function()
        local r2 = combatRemote()
        if r2 then pcall(function() r2:FireServer("Block", false) end) end
    end)
end

-- FEINT: VV cancels your in-progress swing with Requests.Combat:FireServer("Feint")
-- (captured live — the game fires this itself when you press block mid-swing).
-- We track the local swing so we only feint at the BEGINNING of it.
local localSwing = { track = nil, t = 0 }   -- most recent non-looped local anim
local function fireFeint()
    local r = combatRemote()
    if r then pcall(function() r:FireServer("Feint") end) end
end
-- True if we are early enough in a local swing that feinting still cancels it.
local function midSwingBeginning(now)
    local s = localSwing
    if not (s.track and s.track.IsPlaying) then return false end
    return (now - s.t) <= (State.FeintWindow or 0.25)
end

-- Perform a parry: feint first if we're mid-swing (and the option is on), then block.
local function doParry(now)
    if State.Feint and midSwingBeginning(now) then
        fireFeint()           -- cancel our swing so the block can come out
    end
    fireBlock()
end
-- Back-compat alias (older call sites).
local pressM2 = fireBlock

--========================================================
-- DODGE — animations with a saved DODGE timing make us DASH instead of block.
-- VV's dash is a RemoteFunction:
--   ReplicatedStorage.Requests.Dash:InvokeServer("LookVector", <deg>)
-- where <deg> is the horizontal angle to rotate the character's look by to get
-- the dash direction (0 = forward, +90 = left, -90 = right, 180 = back).
-- We dash in the player's CURRENT movement direction (where WASD is held), so
-- pressing A dashes left, D right, S back, etc. If no direction is held we dodge
-- BACKWARD (never straight forward).
--========================================================
local _dashRemote
local function dashRemote()
    if _dashRemote and _dashRemote.Parent then return _dashRemote end
    local req = RS:FindFirstChild("Requests")
    _dashRemote = req and req:FindFirstChild("Dash") or nil
    return _dashRemote
end
local function fireDodge()
    local r = dashRemote(); if not r then return end
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    if not (hrp and hum) then return end
    -- Reference look (the character's facing), flattened to the ground plane.
    local look = hrp.CFrame.LookVector
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 1e-3 then return end
    look = look.Unit
    -- Desired dash direction = where the player is actually moving (WASD).
    local move = hum.MoveDirection
    move = Vector3.new(move.X, 0, move.Z)
    local deg
    if move.Magnitude < 0.1 then
        deg = 180                                    -- not moving -> dodge backward
    else
        move = move.Unit
        -- Signed horizontal angle from look -> move (about the Y axis).
        deg = math.deg(math.atan2(look:Cross(move).Y, look:Dot(move)))
    end
    -- InvokeServer yields for the server reply; run it off the Heartbeat thread.
    task.spawn(function() pcall(function() r:InvokeServer("LookVector", deg) end) end)
end

--========================================================
-- Helpers / filters
--========================================================
local function rootOf(char)
    return char and (char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChildWhichIsA("BasePart"))
end

--========================================================
-- Entity history (deepwoken's EntityHistory, trimmed). Per attacking enemy we
-- keep a short ring of {t, yaw, cf} samples — recorded only while their attack is
-- pending, so it's cheap and bounded. Powers facing PREDICTION (how fast they're
-- turning) and hitbox INTERPOLATION (test their recent past positions too).
--========================================================
local hist = setmetatable({}, { __mode = "k" })  -- char -> { s = {samples}, head }
local HIST_LEN = 8
local function recordHistory(char, now)
    local r = rootOf(char); if not r then return end
    local h = hist[char]
    if not h then h = { s = {}, head = 0 }; hist[char] = h end
    h.head = (h.head % HIST_LEN) + 1
    local lv = r.CFrame.LookVector
    h.s[h.head] = { t = now, yaw = math.atan2(lv.X, lv.Z), cf = r.CFrame }
end
-- Turn rate (rad/s) from the newest sample vs one ~0.05-0.3s older.
local function yawRate(char)
    local h = hist[char]; if not h then return 0 end
    local latest = h.s[h.head]; if not latest then return 0 end
    local prev
    for _, sm in pairs(h.s) do
        local age = latest.t - sm.t
        if sm ~= latest and age >= 0.05 and age <= 0.3 then
            if not prev or sm.t > prev.t then prev = sm end
        end
    end
    if not prev then return 0 end
    local dy = latest.yaw - prev.yaw
    while dy >  math.pi do dy = dy - 2 * math.pi end
    while dy < -math.pi do dy = dy + 2 * math.pi end
    local dt = latest.t - prev.t
    return dt > 0 and (dy / dt) or 0
end

-- Distance gate. Uses this animation's PER-ATTACK range (deepwoken imdd/imxd) if
-- one is saved for it, otherwise the global Detection Range.
local function inRange(char, animId)
    local r = rootOf(char)
    local _, me = getCharParts()
    if not (r and me) then return false end
    local d = (r.Position - me.Position).Magnitude
    local rng = animId and _G.__ParryRanges and _G.__ParryRanges[animId]
    if rng then return d >= (rng.min or 0) and d <= (rng.max or 1e9) end
    return d <= (State.DetectionRange or 18)
end
-- Hitbox prediction — ported from the reference (Defender.hitbox + HitboxOptions):
--   * Build the attack hitbox at the attacker's root CFrame, pushed forward by
--     half its depth: usedCFrame = root.CFrame * CFrame.new(0,0,-Z/2).
--   * Test workspace:GetPartBoundsInBox against our character (are we inside it?).
--   * If spredict and the current box misses, repeat at the EXTRAPOLATED position
--     root.CFrame + root.AssemblyLinearVelocity * ptime  (where will they be when
--     the hit lands). ptime mirrors their fsecs(): 0.15 + ping.
-- We can't pull their per-animation hitbox *sizes* (those live in their Modules),
-- so the box is a cube of Detection Range on every side — the single distance
-- value that also drives the proximity gate, so detection and hitbox can't differ.
local function boxHitsMe(cf, size)
    local myChar = LP.Character
    if not myChar then return false end
    local used = cf * CFrame.new(0, 0, -(size.Z / 2))   -- forward-depth box
    local op = OverlapParams.new()
    op.FilterType = Enum.RaycastFilterType.Exclude       -- robust across executors
    op.FilterDescendantsInstances = {}
    local parts = workspace:GetPartBoundsInBox(used, size, op)
    for _, p in ipairs(parts) do
        if p:IsDescendantOf(myChar) then return true end
    end
    return false
end
local function hitboxCheck(char)
    local r = char:FindFirstChild("HumanoidRootPart") or rootOf(char)
    if not r then return false end
    local R    = State.DetectionRange or 18
    local size = Vector3.new(R, R, R)                     -- width, height, forward reach (all = Detection Range)
    if boxHitsMe(r.CFrame, size) then return true end     -- current position
    -- Predicted position (reference fsecs ~= 0.15 + ping).
    local ptime = 0.15 + (Latency.rtt() or 0)
    if boxHitsMe(r.CFrame + r.AssemblyLinearVelocity * ptime, size) then return true end
    -- History interpolation (deepwoken phd): also test their recent past CFrames,
    -- so a fast-moving attacker or a laggy frame doesn't slip past the box.
    if State.HitboxHistory ~= false then
        local h = hist[char]
        if h then for _, sm in pairs(h.s) do if boxHitsMe(sm.cf, size) then return true end end end
    end
    return false
end
local function isPlayerChar(char)
    return Players:GetPlayerFromCharacter(char) ~= nil
end
-- A "mob" = an enemy that is NOT a player and NOT a dialogue/quest NPC.
-- NPCs are identified the same way ESP does: a ProximityPrompt, an "NPC"
-- attribute, or an IsNPC child (e.g. Village Guards).
local function isNpcChar(char)
    if char:GetAttribute("NPC") or char:FindFirstChild("IsNPC") then return true end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("ProximityPrompt") then return true end
    end
    return false
end
local function isMobChar(char)
    return not isPlayerChar(char) and not isNpcChar(char)
end
-- True if the attacker is roughly facing us (their front points our way).
-- Uses a ~70° cone on the horizontal plane. If we can't tell, allow it.
local function isFacingMe(char)
    local r = rootOf(char)
    local _, me = getCharParts()
    if not (r and me) then return true end
    local to = me.Position - r.Position
    to = Vector3.new(to.X, 0, to.Z)
    if to.Magnitude < 0.1 then return true end
    to = to.Unit
    local look = r.CFrame.LookVector
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.01 then return true end
    look = look.Unit
    local dot = State.FacingDot or 0.35
    if look:Dot(to) >= dot then return true end
    -- Facing PREDICTION (deepwoken pfh): if they're turning, predict where they'll
    -- be aimed when the hit lands and accept that too — catches spins / turn-ins.
    if State.FacingPredict ~= false then
        local rate = yawRate(char)
        if math.abs(rate) > 0.25 then
            local lead = (Latency.rtt() or 0) + 0.12
            local yaw  = math.atan2(look.X, look.Z) + rate * lead
            if Vector3.new(math.sin(yaw), 0, math.cos(yaw)):Dot(to) >= dot then return true end
        end
    end
    return false
end
-- A character is a valid parry target THIS INSTANT only if it passes EVERY
-- active filter. Each filter is an independent AND-gate, so stacking them never
-- ruins another — e.g. Players Only + Hitbox = only parry a PLAYER whose ATTACK
-- hitbox you're standing in.
--   * Players Only / Mobs Only : type filter
--   * Facing Me                : the attacker's front points at you
--   * Hitbox Prediction        : you're inside their ATTACK hitbox (the forward
--                                box ESP draws while they swing). This REFINES
--                                the Detection Range gate (which ALWAYS applies)
--                                — it never widens it, so attacks beyond
--                                Detection Range are always ignored.
-- Nearest Only is applied separately (it picks the nearest target that already
-- passes everything here — so "nearest" means nearest *valid* target).
local function targetOk(char, animId)
    if State.ParryPlayersOnly and not isPlayerChar(char) then return false end
    if State.ParryMobsOnly    and not isMobChar(char)    then return false end
    if State.ParryFacingMe    and not isFacingMe(char)   then return false end
    -- HARD outer wall: never react beyond range — this attack's PER-ATTACK range
    -- if it has one saved, else the global Detection Range. Applies in BOTH modes.
    if not inRange(char, animId) then return false end
    -- Hitbox Prediction only REFINES within that range: you must also be inside
    -- the attacker's forward attack box (itself sized to Detection Range).
    if State.HitboxPredict then return hitboxCheck(char) end
    return true
end

-- The SINGLE closest enemy to you. Ported from type-soul-rewrite's
-- Entitites.findNearestEntity / Targeting.viable (and deepwoken-rewrite's
-- Targeting.viable, same logic): enumerate the game's authoritative character
-- folder (workspace.Entities — deepwoken uses workspace.Live), require a Humanoid +
-- HumanoidRootPart + Health > 0, ignore the local character, and pick the smallest
-- (root.Position - localRoot.Position).Magnitude ("Closest In Distance" sort = du).
-- VV's targetOk is layered on so your Players/Mobs/Facing/range toggles still apply.
-- Falls back to players + attacking mobs if the game has no Entities/Live folder.
local function nearestTarget()
    local _, me = getCharParts(); if not me then return nil end
    local best, bd
    local function consider(c)
        if not c or c == LP.Character then return end
        local hum = c:FindFirstChildWhichIsA("Humanoid")
        local root = c:FindFirstChild("HumanoidRootPart")
        if not (hum and root) or hum.Health <= 0 then return end          -- reference validity check
        -- Respect your Players/Mobs toggles, but DON'T gate selection by the parry
        -- Detection Range — that's what made it pick nil/the wrong target. We lock to
        -- the genuinely closest PLAYER OR MOB so it re-locks the instant someone else
        -- (player included) is nearer. The fire loop still enforces range per attack.
        if State.ParryPlayersOnly and not isPlayerChar(c) then return end
        if State.ParryMobsOnly    and not isMobChar(c)    then return end
        local d = (root.Position - me.Position).Magnitude                 -- du: distance to us
        if not bd or d < bd then bd = d; best = c end
    end
    -- Type Soul keeps players + mobs in workspace.Living; the reference names
    -- (Entities/Live) are other games. (DialogueInteractables = dialogue NPCs, skip.)
    local ents = workspace:FindFirstChild("Living")
        or workspace:FindFirstChild("Entities") or workspace:FindFirstChild("Live")
    if ents then
        for _, e in ipairs(ents:GetChildren()) do consider(e) end
    else
        for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LP then consider(pl.Character) end end
        for _, s in pairs(pending) do consider(s.char) end
    end
    return best
end
_G.__VVnearest = nearestTarget   -- debug handle: call from console to see the current pick

-- Throttle the scan to ~10/sec (cached between) so it's cheap no matter how many
-- entities are in Living — the closest target doesn't change within 100ms anyway.
local cachedNearest, lastNearestT = nil, 0
local function getNearest(now)
    if now - lastNearestT >= 0.1 then lastNearestT = now; cachedNearest = nearestTarget() end
    return cachedNearest
end

-- Never parry while the Roblox window is unfocused (unless allowed).
local windowFocused = true
Conns.add(UIS.WindowFocused:Connect(function() windowFocused = true end))
Conns.add(UIS.WindowFocusReleased:Connect(function() windowFocused = false end))

--========================================================
-- Timings (YOUR saved timings)
--========================================================
local function getTimes(animId)
    local pt = _G.__ParryTimings
    return (pt and pt.getTimes and pt.getTimes(animId)) or {}
end
local function getDodges(animId)
    local pt = _G.__ParryTimings
    return (pt and pt.getDodges and pt.getDodges(animId)) or {}
end

local function plan(track, char, animId)
    if pending[track] then return end
    local apd = _G.__AutoParryData
    if apd and apd.notePlay then apd.notePlay(animId) end
    -- One event per DISTINCT timing (collapse near-duplicates within 10ms) so we
    -- act exactly once per timing: once for a single-timing attack, and once on
    -- EACH timing for a multi-hit attack — never twice for the same one.
    -- Parry timings BLOCK; dodge timings DASH (kind tags which to do).
    local events = {}
    local function addEvents(list, kind)
        for _, sec in ipairs(list) do
            sec = math.max(sec, 0)
            local dup = false
            for _, ev in ipairs(events) do
                if ev.kind == kind and math.abs(ev.at - sec) < 0.01 then dup = true; break end
            end
            if not dup then events[#events+1] = { at = sec, fired = false, kind = kind } end
        end
    end
    addEvents(getTimes(animId),  "parry")
    addEvents(getDodges(animId), "dodge")
    if #events == 0 then return end          -- no saved timing -> ignore
    pending[track] = { animId = animId, char = char, events = events }
    local stopConn
    stopConn = track.Stopped:Connect(function()
        pending[track] = nil
        if stopConn then stopConn:Disconnect() end
    end)
    Conns.add(stopConn)
end

--========================================================
-- Smart Hit: while a REAL parry is about to fire (a tracked enemy attack is within
-- `window` track-seconds of its timing AND passes the target filters), cancel our
-- own swing so we don't whiff into it. Weak-keyed so each swing is feinted once.
--========================================================
local smartFeinted = setmetatable({}, { __mode = "k" })
-- Smallest track-time until a REAL upcoming parry fires (nil if none imminent).
-- Powers Auto Feint's timing (Passive/Aggressive + Delayed).
local function imminentParryDt(now, lead)
    local best
    for track, s in pairs(pending) do
        if track and track.IsPlaying then
            local spd    = (track.Speed and track.Speed > 0) and track.Speed or 1
            local predTP = track.TimePosition + lead / spd
            for _, ev in ipairs(s.events) do
                if ev.kind ~= "dodge" and not ev.fired then
                    local dt = ev.at - predTP            -- track-time until this parry fires
                    if dt >= -0.05 and targetOk(s.char, s.animId) and (not best or dt < best) then
                        best = dt
                    end
                end
            end
        end
    end
    return best
end

--========================================================
-- deepwoken extras: AP-breaker filter + Repeat-Until-Parry-End (failure
-- simulation is inline in the fire tick below).
--========================================================
-- A track that looks like an AP-breaker bait: a barely-weighted "fake" animation,
-- or one spoofed to an abnormal playback speed to blow through the timing.
local function looksSpoofed(track)
    if not track then return false end
    if (track.WeightTarget or 1) <= 0.08 then return true end
    if (track.Speed or 1) >= (State.APBreakerSpeed or 6) then return true end
    return false
end
-- Repeat Until Parry End: after the first parry, keep re-blocking every interval
-- while the same attack track is still playing (deepwoken's RPUE) — so a drawn-out
-- or multi-hit attack stays blocked. One loop per track; stops if you move out.
local rpueActive = setmetatable({}, { __mode = "k" })
local function startRPUE(track, char, animId)
    if rpueActive[track] then return end
    rpueActive[track] = true
    task.spawn(function()
        local t0 = os.clock()
        while track.IsPlaying and (os.clock() - t0) < 5 do
            task.wait((State.RPUEInterval or 200) / 1000)
            if not (track.IsPlaying and State.AutoParry and State.RPUE) then break end
            if targetOk(char, animId) then
                doParry(os.clock())
                lastReactT = os.clock()
            end
        end
        rpueActive[track] = nil
    end)
end

--========================================================
-- Fire tick — compares the track's OWN TimePosition to your saved timing,
-- so the parry lands on the exact saved frame regardless of playback speed.
--========================================================
-- Forward declaration: the SEPARATE projectile-defender loop (added after this
-- one) references updateProjWatch, which is defined further below; without this
-- forward local the name would bind to a nil global and throw.
local updateProjWatch
-- AUTO PARRY — animation-timing ONLY. Fully independent of the projectile
-- (Hitbox Range) system, which runs in its own loop below. This loop never
-- touches projectile state and the projectile loop never touches this one.
Conns.add(RunService.Heartbeat:Connect(function()
    if not State or not State.AutoParry then return end
    local now = os.clock()
    if not windowFocused and not State.ParryWhenUnfocused then return end
    if now < hitstunUntil then return end

    -- Lead the parry by your round-trip ping (so the block reaches the server in
    -- time — without this, parries fire too late at any real ping and miss) plus
    -- your manual Timing Offset. This is internal AutoParry timing, not a toggle.
    local lead = (Latency.rtt() or 0) + (State.TimingOffset or 0)
    -- High Ping Mode: press a touch earlier (a fraction of ping) so the block is
    -- already up if jitter makes the hit arrive early; the longer block hold
    -- covers it arriving late.
    if State.HighPing then lead = lead + (Latency.rtt() or 0) * 0.25 end
    local nearest = State.ParryNearestOnly and getNearest(now) or nil

    for track, s in pairs(pending) do
        if not track or not track.IsPlaying then
            pending[track] = nil
        else
            recordHistory(s.char, now)   -- feed facing-prediction + hitbox history
            -- AnimatorDefender:tp() — predicted time position:
            --   TimePosition + (offset + lead) / Speed
            local spd     = (track.Speed and track.Speed > 0) and track.Speed or 1
            local predTP  = track.TimePosition + lead / spd
            for _, ev in ipairs(s.events) do
                -- Fire once the predicted position has crossed the keyframe.
                -- ev.fired makes each timing fire EXACTLY ONCE; there's no global
                -- cooldown, so a multi-timing animation still parries on every
                -- timing even when two are close together.
                if not ev.fired and predTP >= ev.at then
                    if targetOk(s.char, s.animId)
                       and (not State.ParryNearestOnly or s.char == nearest)
                       and not (ev.kind == "dodge" and State.AutoDodge == false) then
                        if (State.APBreaker and looksSpoofed(track))
                           or (State.FailSim and math.random(100) <= (State.FailRate or 0)) then
                            ev.fired = true     -- skip: AP-breaker bait / intentional human miss
                        else
                            if ev.kind == "dodge" then fireDodge() else doParry(now) end
                            ev.fired = true
                            lastFire = now
                            lastReactT = now            -- shared with Hitbox Range (anti double-fire)
                            lastParry.track, lastParry.t, lastParry.count = track, now, 0
                            _G.__lastParry = string.format("%s %s set=%dms lead=%dms @%dms",
                                ev.kind or "parry", s.animId, math.floor(ev.at * 1000),
                                math.floor(lead * 1000), math.floor(track.TimePosition * 1000))
                            if State.RPUE and ev.kind ~= "dodge" then startRPUE(track, s.char, s.animId) end
                        end
                    end
                end
            end
        end
    end

    -- Auto Feint (deepwoken-style): while you're mid-swing and a REAL parry is
    -- coming, feint your swing so you don't whiff into it (AutoParry still blocks
    -- at its own timing). Outside a window your swings go through normally.
    --   Passive    — only feint if the enemy hit would land BEFORE your swing
    --                ends (lets safe swings finish, like deepwoken's Passive).
    --   Aggressive — always feint as soon as the window opens.
    --   Delayed Feints — hold the feint to the last moment instead of early.
    if State.SmartHit then
        local sw = localSwing
        if sw.track and sw.track.IsPlaying and not smartFeinted[sw.track] then
            local dt = imminentParryDt(now, lead)
            if dt then
                local window  = State.SmartHitWindow or 0.25
                local trigger = State.DelayedFeints and math.min(0.06, window) or window
                local within  = dt <= trigger and dt >= -0.05
                local pass = true
                if State.AutoFeintType == "Passive" then
                    local spd = (sw.track.Speed and sw.track.Speed > 0) and sw.track.Speed or 1
                    local swingLeft = (sw.track.Length - sw.track.TimePosition) / spd
                    pass = dt < swingLeft   -- enemy lands before our swing ends
                end
                if within and pass then
                    fireFeint()
                    smartFeinted[sw.track] = true
                end
            end
        end
    end
end))

-- PROJECTILE HITBOX PARRY — its OWN loop, fully independent of AutoParry above.
-- Watches only the saved/captured projectiles and reacts the instant one enters
-- your hitbox, using ONLY its own ranges/delays (never AutoParry's Detection
-- Range or animation timings). Runs whenever Hitbox Range mode is on, regardless
-- of the AutoParry toggle. (lastReactT is shared purely to avoid a double-block
-- if an animation parry and a projectile parry coincide.)
Conns.add(RunService.Heartbeat:Connect(function()
    if State and State.HitboxRangeMode then updateProjWatch(os.clock()) end
end))

--========================================================
-- ESP attack-hitbox tracker
--
-- Records which enemies are CURRENTLY mid-attack, and whether the swing is a
-- Critical, so Visuals can draw the parry hitbox box ONLY while they're actually
-- attacking — green for normal/M1 swings, red for criticals. This runs no matter
-- whether AutoParry is on, so the ESP "Show Hitboxes" option works on its own.
--========================================================
local attacking = setmetatable({}, { __mode = "k" })   -- char -> { n=int, crit=int }
function Combat.attackInfo(char)
    local r = attacking[char]
    if not r then return nil end
    return { critical = (r.crit or 0) > 0 }
end
_G.__AttackInfo = Combat.attackInfo

-- Is this animation an attack we should draw a box for? Saved timing, a learned
-- attack, or a name that categorises as a swing all count.
local function isAttackAnim(animId, cat)
    if #getTimes(animId) > 0 then return true end
    local apd = _G.__AutoParryData
    if apd and apd.isAttack and apd.isAttack(animId) then return true end
    return cat == "M1" or cat == "Critical" or cat == "Heavy"
end
local function noteAttackVisual(owner, track, animId)
    local av  = _G.__AnimViz
    local cat = (av and av.categoryOf and av.categoryOf(animId)) or "Other"
    if not isAttackAnim(animId, cat) then return end
    local wasCrit = (cat == "Critical")
    local rec = attacking[owner]
    if not rec then rec = { n = 0, crit = 0 }; attacking[owner] = rec end
    rec.n = rec.n + 1
    if wasCrit then rec.crit = rec.crit + 1 end
    local stopConn
    stopConn = track.Stopped:Connect(function()
        local r = attacking[owner]
        if r then
            r.n = r.n - 1
            if wasCrit then r.crit = math.max(0, r.crit - 1) end
            if r.n <= 0 then attacking[owner] = nil end
        end
        if stopConn then stopConn:Disconnect() end
    end)
    Conns.add(stopConn)
end

--========================================================
-- Hook enemy humanoids + non-humanoid rigs + local hit-stun
--========================================================
--========================================================
-- HITBOX RANGE — projectile defender (ported from deepwoken's PartDefender).
--
-- We match incoming projectiles by PART NAME (or an ancestor's name) against a
-- saved set (_G.__ProjectileNames, seeded with Type Soul's Cero). Only matched
-- parts are watched, so the thousands of unrelated Debris effects cost nothing.
-- A watched part reacts ONCE the moment its (inflated) hitbox touches you —
-- "delay until in hitbox", exactly like the reference.
--========================================================
local projWatch = {}            -- BasePart -> spawn os.clock()
local projConn                  -- Debris DescendantAdded (only while mode on)
local PROJ_TTL = 8              -- seconds before a watched part is dropped

-- Projectile DEBUG log (Projectiles tab → Debug). Records, for SAVED projectiles,
-- what the defender did: DETECT (saw it), PARRY/DODGE (reacted), NO PARRY (left range
-- without reacting), FAILED (reacted but you still took damage). Gated by ProjDebug
-- so it costs nothing when off. The menu reads _G.__ProjDebug and polls .rev.
local ProjDebug = { log = {}, rev = 0 }
_G.__ProjDebug = ProjDebug
local lastProjFire = nil        -- { name, t } of the most recent projectile reaction
local function pdbg(kind, name, info)
    if not (State and State.ProjDebug) then return end
    table.insert(ProjDebug.log, 1, { kind = kind, name = name or "?", info = info, t = os.clock() })
    while #ProjDebug.log > 60 do table.remove(ProjDebug.log) end
    ProjDebug.rev = ProjDebug.rev + 1
end

-- Returns the SAVED name that matched (the part's own name or an ancestor's), or nil.
local function matchProjectileName(part)
    local set = _G.__ProjectileNames
    if not set then return nil end
    if set[part.Name] then return part.Name end
    local p = part.Parent
    for _ = 1, 3 do
        if not p or p == workspace then break end
        if set[p.Name] then return p.Name end
        p = p.Parent
    end
    return nil
end
-- Per-projectile parry delay (SECONDS) for a saved name, or nil if it has no override
-- (then the global Hitbox Parry Delay applies). Stored in the capture list as {d=ms};
-- a plain `true` value = no override. Lets each projectile parry at its own delay.
local function projDelay(name)
    local set = _G.__ProjectileNames
    local v = name and set and set[name]
    if type(v) == "table" and v.d ~= nil then return (tonumber(v.d) or 0) / 1000 end
    return nil
end
-- DescendantAdded handler (connected only while the mode is on). Two ways a part
-- gets watched:
--   * NAMED   — its name (or an ancestor's) is in the capture list. Trusted: reacts
--               the instant its box reaches you (no motion proof needed).
--   * AUTO    — name-agnostic. ANY newly-spawned part of plausible projectile size
--               is watched; updateProjWatch only reacts once it PROVES it's a real
--               projectile (it has travelled and is approaching you). This is what
--               lets us catch new abilities WITHOUT having their name in the list.
local function biggestAxis(sz) return math.max(sz.X, sz.Y, sz.Z) end
local function considerProjectile(part)
    if not (State and State.HitboxRangeMode) then return end   -- gated here, always connected
    if not part:IsA("BasePart") then return end
    if projWatch[part] then return end
    local named = matchProjectileName(part)
    if not named then
        if not State.HitboxAutoDetect then return end
        -- Skip tiny particles (sparks/blood/embers) and oversized terrain chunks —
        -- real projectiles sit between these bounds. NOTE: Type Soul ceros can be
        -- ~100 studs, so the upper bound is deliberately high (see HitboxAutoMaxAxis).
        local a = biggestAxis(part.Size)
        if a < (State.HitboxAutoMinAxis or 1.2) or a > (State.HitboxAutoMaxAxis or 130) then return end
    end
    -- Distance requirement: only watch a projectile that APPEARS at least
    -- HitboxMinDist studs away — so local melee-effect particles (which spawn
    -- right on you) are ignored. 0 = off. Tunable in the Hitbox Range menu.
    local minD = State.HitboxMinDist or 0
    if minD > 0 then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (part.Position - hrp.Position).Magnitude < minD then return end
    end
    projWatch[part] = { t0 = os.clock(), lastPos = part.Position, lastDist = math.huge, moved = 0, named = named, parryDelay = projDelay(named) }
    if named then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local dist = hrp and math.floor((part.Position - hrp.Position).Magnitude) or -1
        pdbg("DETECT", part.Name, "saved projectile, " .. dist .. " studs away")
    end
end
local function connectProjectiles()
    if projConn then return end
    local src = workspace:FindFirstChild("Debris") or workspace
    projConn = Conns.add(src.DescendantAdded:Connect(considerProjectile))
end

-- Per-tick: for each watched projectile, react ONCE its (inflated) box touches us.
local _projOP = OverlapParams.new()
_projOP.FilterType = Enum.RaycastFilterType.Include
local _projChar
function updateProjWatch(now)
    if not windowFocused and not State.ParryWhenUnfocused then return end
    local myChar = LP.Character
    if not myChar then return end
    if _projChar ~= myChar then _projOP.FilterDescendantsInstances = { myChar }; _projChar = myChar end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myHrp and myHrp.Position
    local doDodge = State.HitboxRangeDodge and (State.HitboxRangeParry == false)
    local m = doDodge and (State.HitboxDodgeRange or 25) or (State.HitboxParryRange or 25)
    local maxD = State.HitboxMaxDist or 0        -- max engage distance (0 = unlimited)
    local inflate = Vector3.new(m * 2, m * 2, m * 2)
    for part, rec in pairs(projWatch) do
        if not part.Parent or (now - rec.t0) > PROJ_TTL then
            if rec.named then pdbg("NO PARRY", part.Name, "left range / despawned without reaching you") end
            projWatch[part] = nil
        else
            -- Motion bookkeeping + REAL surface distance from you to the projectile.
            local edge = math.huge
            if myPos then
                local d = (part.Position - myPos).Magnitude
                rec.moved = rec.moved + (part.Position - rec.lastPos).Magnitude
                rec.approaching = d < (rec.lastDist - 0.15)
                rec.lastPos = part.Position; rec.lastDist = d
                -- Closest point on the projectile's ORIENTED box to your body: 0 when
                -- the part covers you, else the gap to its nearest surface. This is the
                -- true "is the threat on me" test — a giant beam fires at edge 0 (when it
                -- actually reaches you), a small projectile fires at range m (lead time) —
                -- unlike inflating a 90-stud part, which fired when it was 60 studs away.
                local lpos = part.CFrame:PointToObjectSpace(myPos)
                local hs = part.Size * 0.5
                local cx = math.clamp(lpos.X, -hs.X, hs.X)
                local cy = math.clamp(lpos.Y, -hs.Y, hs.Y)
                local cz = math.clamp(lpos.Z, -hs.Z, hs.Z)
                edge = (lpos - Vector3.new(cx, cy, cz)).Magnitude
            end
            -- NAMED parts are trusted immediately; AUTO parts must have travelled and
            -- be currently approaching before we'll treat them as an incoming threat.
            local eligible = rec.named or (rec.approaching and rec.moved > 6)
            -- Max engage distance: ignore a projectile whose CENTRE is beyond maxD (0 = off).
            if maxD > 0 and rec.lastDist > maxD then
                -- too far to engage; skip (it may come closer on a later tick)
            elseif eligible and (now - lastReactT) >= REACT_CD and edge <= m then
                projWatch[part] = nil
                lastReactT = now
                lastProjFire = { name = part.Name, t = now }
                pdbg(doDodge and "DODGE" or "PARRY", part.Name,
                    (rec.named and "saved" or "auto") .. ", fired at " .. math.floor(edge) .. " studs")
                if doDodge then
                    local d = State.HitboxDodgeDelay or 0
                    if d > 0 then task.delay(d, function() fireDodge() end) else fireDodge() end
                else
                    -- per-projectile delay (if this saved projectile set one) else global
                    local d = rec.parryDelay
                    if d == nil then d = State.HitboxParryDelay or 0 end
                    if d > 0 then task.delay(d, function() doParry(os.clock()) end) else doParry(os.clock()) end
                end
            end
        end
    end
end

-- Measure-on-Hit: registry of every enemy attack animation CURRENTLY playing
-- (not just ones we already have a timing for — that's the whole point). When one
-- damages us, we read its TimePosition = the exact frame the hit landed, and save
-- that as the move's impact timing. Lets you build your own answer-key just by
-- letting moves tag you once, no manual parry skill required.
local measureLive = setmetatable({}, { __mode = "k" })   -- track -> { owner, id }
local function registerMeasure(owner, track, id)
    if measureLive[track] then return end
    measureLive[track] = { owner = owner, id = id }
    local c; c = track.Stopped:Connect(function()
        measureLive[track] = nil
        if c then c:Disconnect() end
    end)
    Conns.add(c)
end

-- Shared handler: a track started on some enemy rig (humanoid OR controller).
local function onEnemyAnim(owner, track)
    if not owner or owner == LP.Character then return end
    local anim = track.Animation
    local id = (anim and anim.AnimationId or ""):gsub("rbxassetid://", "")
    if id == "" then return end
    noteAttackVisual(owner, track, id)            -- ESP hitbox tracking (always on)
    if State and State.MeasureOnHit and not track.Looped then registerMeasure(owner, track, id) end
    if not State or not State.AutoParry then return end
    plan(track, owner, id)
end

local hookedHums = setmetatable({}, { __mode = "k" })
local function hookHum(hum)
    if hookedHums[hum] then return end
    hookedHums[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        onEnemyAnim(hum.Parent, track)
    end))
end
Humanoids.onAdded(hookHum)

-- Many VV mobs are NON-humanoid rigs driven by an AnimationController instead
-- of a Humanoid (the Animation Visualizer hooks these; AutoParry must too, or
-- their attacks are never seen and their saved timings never fire).
local hookedCtrls = setmetatable({}, { __mode = "k" })
local function hookCtrl(ctrl)
    if hookedCtrls[ctrl] then return end
    hookedCtrls[ctrl] = true
    Conns.add(ctrl.AnimationPlayed:Connect(function(track)
        -- AnimationController usually sits directly under the rig model.
        onEnemyAnim(ctrl.Parent, track)
    end))
end
for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("AnimationController") then hookCtrl(d) end
end
Conns.add(workspace.DescendantAdded:Connect(function(o)
    if o:IsA("AnimationController") then hookCtrl(o) end
end))

-- Recent-projectile tracker for Measure-on-Hit. The damaging part is the one that
-- TRAVELLED and APPROACHED you (the cero beam, e.g. "Start") — NOT the impact effect
-- that just spawns on you (e.g. "ColorPart"/"Particles1"), which has no lead time and
-- is useless to Hitbox Range. So we track motion: any new Debris part is followed,
-- and the one that moved + is closing in + is close + projectile-sized is remembered.
local moTrack  = setmetatable({}, { __mode = "k" })   -- part -> {lastPos,lastDist,moved,t0}
local moRecent = { name = nil, t = -1 }
Conns.add((workspace:FindFirstChild("Debris") or workspace).DescendantAdded:Connect(function(p)
    if not (State and State.MeasureOnHit) then return end
    if not p:IsA("BasePart") or moTrack[p] then return end
    local _, me = getCharParts(); if not me then return end
    local sd = (p.Position - me.Position).Magnitude
    if sd > 200 then return end
    moTrack[p] = { lastPos = p.Position, lastDist = math.huge, moved = 0, t0 = os.clock(), startDist = sd }
end))
local _moT = 0
Conns.add(RunService.Heartbeat:Connect(function()
    if not (State and State.MeasureOnHit) then return end
    local now = os.clock(); if now - _moT < 0.05 then return end; _moT = now
    local _, me = getCharParts(); if not me then return end
    local myPos = me.Position
    for p, t in pairs(moTrack) do
        if not p.Parent or (now - t.t0) > 8 then
            moTrack[p] = nil
        else
            local d = (p.Position - myPos).Magnitude
            t.moved = t.moved + (p.Position - t.lastPos).Magnitude
            local approaching = d < (t.lastDist - 0.2)
            t.lastPos = p.Position; t.lastDist = d
            local sz = math.max(p.Size.X, p.Size.Y, p.Size.Z)
            -- Only PARRYABLE projectiles: it ORIGINATED far away (≥14 studs — not an
            -- on-you impact effect), has TRAVELLED a real path, is still closing in,
            -- and is projectile-sized. This is what gives Hitbox Range lead time.
            if approaching and t.startDist >= 14 and t.moved > 8 and d <= 26
               and sz >= 1.2 and sz <= 130 then
                moRecent.name = p.Name; moRecent.t = now
            end
        end
    end
end))

-- On taking damage, STAGE what hit you into the "Learn on Misses" review queue
-- (NOT your live timings) — nothing is auto-applied; you review and Add each one.
--   * MELEE / animated attack from a nearby swinging enemy -> stage the timing
--     (the exact impact frame, nudged earlier by half your ping).
--   * PROJECTILE / cero (no close swinger, a Debris part just overlapped you) ->
--     stage the projectile NAME for the Hitbox Range list.
local function measureOnHit()
    if not (State and State.MeasureOnHit) then return end
    local lom = _G.__LearnOnMiss; if not (lom and lom.add) then return end
    local _, me = getCharParts(); if not me then return end

    -- 1) Nearest enemy MID-ATTACK within melee range -> animation timing.
    local bestId, bestOwner, bestTP, bd
    local melee = (State.DetectionRange or 18) + 10
    for track, info in pairs(measureLive) do
        if track.IsPlaying and info.owner and info.owner.Parent and info.owner ~= LP.Character then
            local r = rootOf(info.owner)
            if r then
                local d = (r.Position - me.Position).Magnitude
                if d <= melee and (not bd or d < bd) then bd = d; bestId = info.id; bestOwner = info.owner; bestTP = track.TimePosition end
            end
        end
    end
    if bestId and bestTP then
        if #getTimes(bestId) > 0 then return end                  -- already have it
        local impact = bestTP - (Latency.rtt() or 0) * 0.5
        if impact < 0.02 then return end
        local cat = (bestOwner and bestOwner.Name) or "Learn on Miss"
        if lom.add(bestId, impact, cat) and _G.__Notify then
            _G.__Notify("Learned (review it)", cat .. " @ " .. math.floor(impact * 1000) .. "ms", 2, Color3.fromRGB(120,200,235))
        end
        return
    end

    -- 2) No close swinger -> it was a projectile/cero. Stage its NAME (Hitbox Range).
    if moRecent.name and (os.clock() - moRecent.t) <= 0.6 then
        local set = _G.__ProjectileNames
        if set and set[moRecent.name] then return end             -- already a known projectile
        if lom.addProj and lom.addProj(moRecent.name) and _G.__Notify then
            _G.__Notify("Learned projectile", moRecent.name .. " (review it)", 2, Color3.fromRGB(120,200,235))
        end
    end
end

local function bindLocal(char)
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    -- Track the local swing so we can feint at the START of it. Looped tracks
    -- (idle / run) are ignored; a swing is a one-shot animation.
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        if track and not track.Looped then
            localSwing.track, localSwing.t = track, os.clock()
        end
    end))
    local lastHP = hum.Health
    Conns.add(hum.HealthChanged:Connect(function(h)
        if h < lastHP then
            local t = os.clock()
            hitstunUntil = t + HITSTUN
            -- Projectile debug: if we fired a projectile parry/dodge just before this
            -- damage, it didn't save us — log the failure so you can see it.
            if lastProjFire and (t - lastProjFire.t) <= 0.6 then
                pdbg("FAILED", lastProjFire.name, "fired a parry but you still took damage")
                lastProjFire = nil
            end
            measureOnHit()        -- learn the move that just hit (if Measure-on-Hit is on)
            -- Repeat on miss: a parry we just fired clearly whiffed (we took
            -- damage). If the attacker's animation is still going, re-fire the
            -- parry to catch the next hit in the combo, up to a capped number.
            if State and State.AutoParry and State.RepeatOnMiss
               and lastParry.track and lastParry.track.IsPlaying
               and (t - lastParry.t) <= 0.6
               and lastParry.count < (State.RepeatOnMissMax or 2) then
                doParry(t)
                lastParry.count = lastParry.count + 1
                lastFire = t
            end
        end
        lastHP = h
    end))
end
if LP.Character then bindLocal(LP.Character) end
Conns.add(LP.CharacterAdded:Connect(bindLocal))

--========================================================
-- API
--========================================================
-- Detection Range — the SINGLE source of truth for every distance check in
-- AutoParry. Setting it pins the proximity gate AND the attack-hitbox
-- width/height/reach to one number, and mirrors it into the legacy keys so the
-- ESP hitbox box (and anything else) reads the very same value — detection range
-- and hitbox range can never disagree. No notification: this is a slider.
local function syncRange(r)
    r = math.max(tonumber(r) or 18, 1)
    State.DetectionRange = r
    State.AutoParryRange = r        -- proximity gate (legacy mirror)
    State.HitboxSize     = r        -- attack-box width & height (legacy mirror)
    State.HitboxReach    = r        -- attack-box forward depth (legacy mirror)
    return r
end
function Combat.setDetectionRange(v) syncRange(v) end

-- Hitbox Range master toggle. Connects the Debris projectile watcher only while
-- on; per-tick updateProjWatch reacts when a matched projectile reaches you.
function Combat.setHitboxRangeMode(on)
    State.HitboxRangeMode = on
    if on then
        connectProjectiles()                 -- ensure connected (idempotent)
    else
        for k in pairs(projWatch) do projWatch[k] = nil end   -- stay connected; body is gated by the flag
    end
end
-- Exposed so the Animation Visualizer's Hitbox Range panel toggles the very same
-- mode (with its connection management) instead of duplicating the logic.
_G.__SetHitboxRangeMode = Combat.setHitboxRangeMode

function Combat.setAutoParry(v)
    State.AutoParry = v
end
function Combat.init(state)
    State = state
    _G.__VVState = State                    -- debug handle (read live State from console)
    syncRange(State.DetectionRange or 18)   -- collapse any stale legacy values to the master on load
    -- Projectile names matched by the Hitbox Range defender. "Start" is the part
    -- that actually travels toward you (the Cero/beam body, confirmed live); the
    -- rest are Cero seeds. Works out of the box.
    local set = Settings.get("projectile_names", nil)
    if type(set) ~= "table" or next(set) == nil then
        set = { Start = true, CeroFX = true, Cero1 = true, Cero = true,
                ChargeEffect = true, wbeam = true, SpitShot = true }
        Settings.set("projectile_names", set)
    end
    _G.__ProjectileNames = set
    connectProjectiles()   -- ALWAYS listen; considerProjectile is gated by State.HitboxRangeMode
    -- Per-attack parry ranges (animId -> {min,max}); set in the Animation Visualizer.
    _G.__ParryRanges = Settings.get("parry_ranges", nil) or {}
end
return Combat

end)
__bundle_register("Utility/Latency", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Latency — mirrors deepwoken-rewrite's Latency module.
-- Uses Stats.Network "Data Ping" (round-trip, ms) so AutoParry can press
-- early enough that the input reaches the server at the saved frame.
local Stats = game:GetService("Stats")

local Latency = {}

-- rtt() is read every frame by the AutoParry tick. Ping doesn't change
-- meaningfully frame-to-frame, so cache it and refresh at most ~10x/sec.
-- This removes a Stats.Network lookup from every Heartbeat with no behaviour
-- change (timing still tracks ping within 0.1s).
local _cached, _cachedAt = 0, 0
local function compute()
    local ok, v = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    if ok and v and v > 0 then return v end
    -- fallback: GetNetworkPing is one-way seconds -> RTT = *2
    local p = 0
    pcall(function() p = game:GetService("Players").LocalPlayer:GetNetworkPing() end)
    return math.max(p * 2, 0)
end
function Latency.rtt()  -- round-trip time, seconds (cached ~0.1s)
    local now = os.clock()
    if now - _cachedAt >= 0.1 then
        _cached = compute()
        _cachedAt = now
    end
    return _cached
end

function Latency.rdelay() return math.max(Latency.rtt() / 2, 0) end  -- receive delay
function Latency.sdelay() return math.max(Latency.rtt() / 2, 0) end  -- send delay

return Latency

end)
__bundle_register("Utility/Char", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Tiny helper: returns (character, hrp, humanoid).
local Players = game:GetService("Players")
return function()
    local c = Players.LocalPlayer.Character
    if not c then return nil end
    return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildWhichIsA("Humanoid")
end

end)
__bundle_register("Features/Visuals", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Visuals: ESP, Fullbright, Low GFX. Owns parents for AnimationVisualizer panels.
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local Lighting   = game:GetService("Lighting")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")
local Humanoids    = require("Utility/Humanoids")

local Visuals = {}
local State

--==============================================================
-- ESP — players + every other Humanoid (mobs). Health bar + dist + name.
-- One BillboardGui per character, reused.
--==============================================================
-- Colors: Player = red, NPC (interactable) = green, Mob (hostile) = orange.
local COL_PLAYER = Color3.fromRGB(235, 70, 70)
local COL_NPC    = Color3.fromRGB(90, 215, 120)
local COL_MOB    = Color3.fromRGB(255, 150, 50)
-- Attack hitbox box colors: green for normal/M1 swings, red for criticals.
local COL_HB_NORMAL = Color3.fromRGB(70, 220, 110)
local COL_HB_CRIT   = Color3.fromRGB(235, 70, 70)
-- Active-state names shown by the "Show States" ESP stat (hoisted; read each tick).
local ESP_STATE_NAMES = { "Blocking", "Riposte", "ProjectileDeflecting" }

local espTags = {}      -- root -> BillboardGui
local espHL   = {}      -- character Model -> Highlight
local espHB   = {}      -- root -> BoxHandleAdornment (parry hitbox box)

-- Attack hitbox box. Mirrors Combat's hitbox check EXACTLY (a cube of
-- State.DetectionRange at the root pushed forward by half its depth), so what
-- you see is the very box AutoParry's "Hitbox Prediction" tests you against.
-- Shown ONLY while the enemy is actually mid-attack (Combat reports this), and
-- colored green for normal/M1 swings, red for criticals.
local function hitboxFor(root, char)
    local info = (State.ESPHitbox and char and _G.__AttackInfo)
        and _G.__AttackInfo(char) or nil
    if not info then
        if espHB[root] then pcall(function() espHB[root]:Destroy() end); espHB[root] = nil end
        return
    end
    local R = State.DetectionRange or State.HitboxSize or 12
    local adorn = espHB[root]
    if not adorn or not adorn.Parent then
        adorn = Instance.new("BoxHandleAdornment")
        adorn.Name = "ESP_Hitbox"
        adorn.ZIndex = 0
        adorn.AlwaysOnTop = true
        adorn.Transparency = 0.6
        adorn.Adornee = root
        adorn.Parent = root
        espHB[root] = adorn
    end
    adorn.Color3 = info.critical and COL_HB_CRIT or COL_HB_NORMAL
    adorn.Size = Vector3.new(R, R, R)               -- width, height, forward reach (all = Detection Range)
    adorn.CFrame = CFrame.new(0, 0, -(R / 2))       -- forward-depth offset (like Combat)
end

-- Two billboards per character:
--  1) TEXT billboard ABOVE the head — stacked centered: NAME / ROLE / DISTANCE / WEAPON.
--  2) HP billboard at TORSO level — horizontal layout: [%] then vertical bar,
--     offset to the camera-left of the character via StudsOffset.X.
local function makeTag(root)
    -- TEXT (above head)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Tag"
    bb.Size = UDim2.new(0, 200, 0, 140)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = root

    local function tl(name, y, h, size, font, color, strokeT)
        local t = Instance.new("TextLabel", bb)
        t.Name = name; t.Text = ""
        t.Size = UDim2.new(1, 0, 0, h); t.Position = UDim2.new(0, 0, 0, y)
        t.BackgroundTransparency = 1
        t.TextSize = size; t.Font = font
        t:SetAttribute("baseSize", size)   -- for the text-scale slider
        t.TextColor3 = color
        t.TextStrokeTransparency = strokeT or 0.35
        t.TextXAlignment = Enum.TextXAlignment.Center
        return t
    end
    -- Combat stats sit at the TOP (above the name), then the name stack below.
    -- BillboardGui does NOT render content above its top edge, so the stats can't
    -- use a negative Y — instead the frame is taller and the name is pushed down,
    -- keeping the stats on-screen. CHANGE THE STAT TEXT COLOR HERE.
    local stats = tl("stats", 2,   52, 12, Enum.Font.GothamBold,  Color3.fromRGB(130,225,255), 0.35)
    stats.TextYAlignment = Enum.TextYAlignment.Bottom
    tl("lbl",   56,  20, 15, Enum.Font.GothamBlack, Color3.fromRGB(255,255,255), 0.3)   -- name
    tl("kind",  76,  14, 12, Enum.Font.GothamBold,  Color3.fromRGB(255,255,255), 0.4)   -- role
    tl("dist",  90,  14, 12, Enum.Font.Gotham,      Color3.fromRGB(235,235,235), 0.4)   -- distance
    tl("hppct", 104, 14, 12, Enum.Font.GothamBold,  Color3.fromRGB(120,230,150), 0.4)   -- health % (split mode)
    tl("wpn",   118, 14, 12, Enum.Font.GothamBold,  Color3.fromRGB(255,225,140), 0.4)   -- weapon

    -- HEALTH (at torso, to the camera-left of the character)
    local hb = Instance.new("BillboardGui")
    hb.Name = "ESP_HP"
    hb.Size = UDim2.new(0, 60, 0, 60)
    hb.StudsOffset = Vector3.new(-2.2, 0, 0)      -- shift left on screen
    hb.AlwaysOnTop = true
    hb.LightInfluence = 0
    hb.Parent = root

    -- Percentage label sits to the LEFT of the bar.
    local pct = Instance.new("TextLabel", hb)
    pct.Name = "pct"; pct.Text = ""
    pct.AnchorPoint = Vector2.new(1, 0.5)
    pct.Position = UDim2.new(1, -14, 0.5, 0)
    pct.Size = UDim2.new(0, 40, 0, 16)
    pct.BackgroundTransparency = 1
    pct.TextColor3 = Color3.fromRGB(255,255,255)
    pct.TextStrokeTransparency = 0.35
    pct.TextSize = 12; pct.Font = Enum.Font.GothamBold
    pct:SetAttribute("baseSize", 12)
    pct.TextXAlignment = Enum.TextXAlignment.Right

    -- Vertical bar to the right of the % text.
    local hpBg = Instance.new("Frame", hb)
    hpBg.Name = "hpBg"
    hpBg.AnchorPoint = Vector2.new(1, 0.5)
    hpBg.Position = UDim2.new(1, -2, 0.5, 0)
    hpBg.Size = UDim2.new(0, 6, 0, 56)
    hpBg.BackgroundColor3 = Color3.fromRGB(30,30,30); hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,3)
    local hp = Instance.new("Frame", hpBg)
    hp.Name = "hp"; hp.AnchorPoint = Vector2.new(0, 1)
    hp.Position = UDim2.new(0, 0, 1, 0); hp.Size = UDim2.new(1, 0, 1, 0)
    hp.BackgroundColor3 = Color3.fromRGB(70,210,90); hp.BorderSizePixel = 0
    Instance.new("UICorner", hp).CornerRadius = UDim.new(0,3)

    return { text = bb, hp = hb }
end

local function tagFor(root)
    local pair = espTags[root]
    if not pair or not pair.text or not pair.text.Parent then
        pair = makeTag(root); espTags[root] = pair
    end
    return pair
end

-- Outline via Highlight (per character model), colored by kind.
local function outlineFor(char, color)
    if not State.ESPOutline then
        if espHL[char] then pcall(function() espHL[char]:Destroy() end); espHL[char] = nil end
        return
    end
    local hl = espHL[char]
    if not hl or not hl.Parent then
        hl = Instance.new("Highlight")
        hl.Name = "ESP_HL"
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = char
        espHL[char] = hl
    end
    hl.FillColor = color
    hl.OutlineColor = color
end

-- Best-effort held-weapon name for a character.
local function getWeapon(char)
    -- VV / Type-Soul: the weapon is a "WeaponModel" model on the character; its
    -- name lives in a WeaponName StringValue (mirrored by a WeaponModelName
    -- attribute and a WeaponType StringValue).
    local wm = char:FindFirstChild("WeaponModel")
    if wm then
        local wn = wm:FindFirstChild("WeaponName")
        if wn and wn:IsA("StringValue") and wn.Value ~= "" then return wn.Value end
        local a = wm:GetAttribute("WeaponModelName")
        if a and tostring(a) ~= "" then return tostring(a) end
        local wt = wm:FindFirstChild("WeaponType")
        if wt and wt:IsA("StringValue") and wt.Value ~= "" then return wt.Value end
    end
    -- Fallbacks for other rigs / games:
    local tool = char:FindFirstChildWhichIsA("Tool")          -- equipped Tool
    if tool then return tool.Name end
    local rh = char:FindFirstChild("RightHand")               -- Deepwoken-style hand weapon
    if rh then
        local hw = rh:FindFirstChild("HandWeapon") or rh:FindFirstChildWhichIsA("Model")
        if hw then return hw.Name end
    end
    local a = char:GetAttribute("Weapon")                     -- attribute / value
    if a and tostring(a) ~= "" then return tostring(a) end
    local sv = char:FindFirstChild("Weapon")
    if sv and sv:IsA("StringValue") and sv.Value ~= "" then return sv.Value end
    return nil
end

-- Per-character caches. Weapon name + the Head reference almost never change, so
-- re-running their FindFirstChild chains EVERY tick for EVERY tag was a big ESP
-- cost at long range. Cache them (weak-keyed; weapon refreshed ~every 1.5s).
local weaponCache = setmetatable({}, { __mode = "k" })   -- char -> { name, t }
local function getWeaponCached(char)
    local c = weaponCache[char]
    local now = os.clock()
    if c and (now - c.t) < 1.5 then return c.name end
    local n = getWeapon(char)
    weaponCache[char] = { name = n, t = now }
    return n
end
local headCache = setmetatable({}, { __mode = "k" })     -- char -> Head BasePart
local function headOf(char)
    local h = headCache[char]
    if h and h.Parent then return h end
    h = char:FindFirstChild("Head")
    headCache[char] = h
    return h
end

-- Best human-readable name for a non-player character (mob / NPC).
-- VV's mob rigs sit under Workspace.Living with EMPTY model names; their real
-- identity lives in attributes (HollowType="MantisHollow", Team="VillageGuard",
-- Race="Hollow"…). Named rigs ("Lost Soul", "Giant Dragonfly") use the model
-- name. So: model name → Humanoid.DisplayName → attributes → string values.
local NAME_SKIP = { DefaultEnemy = true, Default = true, Living = true, Enemy = true, NPC = true }
-- "MantisHollow" -> "Mantis Hollow", "VillageGuard" -> "Village Guard".
local function prettify(s)
    s = tostring(s):gsub("(%l)(%u)", "%1 %2"):gsub("(%u%u)(%u%l)", "%1 %2")
    return s
end
local function pickAttr(char)
    for _, a in ipairs({ "MobName", "EnemyName", "DisplayName", "Title",
                         "HollowType", "Name", "Race", "Team" }) do
        local v = char:GetAttribute(a)
        if type(v) == "string" and v ~= "" and not NAME_SKIP[v] then return prettify(v) end
    end
end
-- Names never change for a given character; resolve once and cache (weak-keyed
-- so dead characters are collected). Avoids re-scanning attributes every tick.
local nameCache = setmetatable({}, { __mode = "k" })
local function bestNameUncached(char, hum)
    -- 1) explicit, meaningful model name
    local mn = char.Name
    if mn and mn ~= "" and not NAME_SKIP[mn] then return mn end
    -- 2) humanoid display name
    if hum and type(hum.DisplayName) == "string"
        and hum.DisplayName ~= "" and hum.DisplayName ~= "Humanoid" then
        return hum.DisplayName
    end
    -- 3) VV attributes
    local a = pickAttr(char); if a then return a end
    -- 4) string-value children
    for _, n in ipairs({ "DisplayName", "MobName", "Title" }) do
        local o = char:FindFirstChild(n)
        if o and o:IsA("StringValue") and o.Value ~= "" then return o.Value end
    end
    return (mn ~= "" and mn) or "Enemy"
end
local function bestName(char, hum)
    local hit = nameCache[char]
    if hit ~= nil then return hit end
    local n = bestNameUncached(char, hum)
    nameCache[char] = n
    return n
end

-- Apply the user's text-scale to every label in a tag pair (only when the
-- scale actually changed, so it's free at steady state).
local function applyScale(pair, sc)
    if pair._scale == sc then return end
    pair._scale = sc
    for _, bb in ipairs({ pair.text, pair.hp }) do
        for _, t in ipairs(bb:GetDescendants()) do
            local base = t:GetAttribute("baseSize")
            if base then t.TextSize = math.max(1, math.floor(base * sc + 0.5)) end
        end
    end
end

-- Race / form label (mobs: HollowType / Race attribute; players: Race attribute
-- or a Status.Race string value). prettify() turns "MantisHollow" -> "Mantis Hollow".
local function getRace(char)
    local ht = char:GetAttribute("HollowType")
    if type(ht) == "string" and ht ~= "" then return prettify(ht) end
    local r = char:GetAttribute("Race")
    if type(r) == "string" and r ~= "" then return prettify(r) end
    local st = char:FindFirstChild("Status")
    local sr = st and st:FindFirstChild("Race")
    if sr and sr:IsA("StringValue") and sr.Value ~= "" then return prettify(sr.Value) end
    return nil
end

--==============================================================
-- 2D SCREEN-SPACE BOX + side health bar (Drawing API, executor-provided).
-- A box that frames the character with a vertical health bar to its left.
-- Positioned every RenderStepped (smooth), but only over already-tracked
-- targets, so it costs a couple of WorldToViewportPoint calls per visible enemy.
-- Defined ABOVE updateTag so updateTag's references resolve to these locals.
--==============================================================
local DrawingLib = (type(Drawing) == "table" and Drawing) or nil
local espBox = {}      -- root -> { box, barbg, bar, color, frac }
local function removeBox(root)
    local b = espBox[root]; if not b then return end
    pcall(function() b.box:Remove() end)
    pcall(function() b.barbg:Remove() end)
    pcall(function() b.bar:Remove() end)
    espBox[root] = nil
end
local function boxFor(root)
    if not DrawingLib then return nil end
    local b = espBox[root]; if b then return b end
    local function sq(filled)
        local s = DrawingLib.new("Square")
        s.Thickness = 1; s.Filled = filled; s.Transparency = 1; s.Visible = false
        return s
    end
    b = { box = sq(false), barbg = sq(true), bar = sq(true) }
    b.barbg.Color = Color3.fromRGB(18,18,18)
    espBox[root] = b
    return b
end

local function updateTag(root, char, name, kind, color, hum, dist)
    local pair = tagFor(root)
    local txt, hb = pair.text, pair.hp
    applyScale(pair, (State.ESPTextScale or 100) / 100)

    -- Reposition the text billboard so it sits just above the head.
    do
        local head = headOf(char)
        local r = root
        if head and r and head:IsA("BasePart") and r:IsA("BasePart") then
            local dy = (head.Position.Y - r.Position.Y) + (head.Size.Y * 0.5) + 2.4
            txt.StudsOffset = Vector3.new(0, dy, 0)
        end
    end

    txt.lbl.Text = State.ESPName and name or ""
    txt.lbl.TextColor3 = color
    -- Name gets its OWN scale on top of the overall ESP text scale.
    txt.lbl.TextSize = math.max(1, math.floor((txt.lbl:GetAttribute("baseSize") or 15)
        * ((State.ESPTextScale or 100) / 100) * ((State.ESPNameScale or 100) / 100) + 0.5))
    txt.kind.Text = kind
    txt.kind.TextColor3 = Color3.fromRGB(255,255,255)
    txt.dist.Text = State.ESPDistance and string.format("%dm", dist) or ""
    -- Weapon: players + mobs only (not NPCs)
    local showWpn = State.ESPWeapon and kind ~= "NPC"
    if showWpn then
        local w = getWeaponCached(char)
        txt.wpn.Text = w and ("[" .. w .. "]") or ""
        txt.wpn.Visible = w ~= nil
    else
        txt.wpn.Visible = false
    end

    -- Health: side panel (vertical bar + %) by default; in Split mode the side
    -- panel is hidden entirely and only the % shows in the text stack.
    local showHp = State.ESPHealth and hum ~= nil
    local split  = State.ESPSplitHealth
    hb.Enabled = showHp and not split
    if showHp then
        local p = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local pctTxt = string.format("%d%%", math.floor(p*100 + 0.5))
        local barCol = Color3.fromRGB(
            math.floor(235*(1-p)+60), math.floor(70 + 150*p), 70)
        if not split then
            local bar = hb.hpBg.hp
            bar.Size = UDim2.new(1, 0, p, 0)
            bar.BackgroundColor3 = barCol
            hb.pct.Visible = true
            hb.pct.Text = pctTxt
            hb.pct.TextColor3 = Color3.fromRGB(255,255,255)
            txt.hppct.Visible = false
        else
            txt.hppct.Visible = true
            txt.hppct.Text = pctTxt
            txt.hppct.TextColor3 = barCol
        end
    else
        txt.hppct.Visible = false
    end
    -- Combat-state stats: one multi-line label above the name. Status is only
    -- looked up when a value-stat is on, and `lines` is built lazily, so an idle
    -- tick (no stats shown — the common case) allocates nothing.
    do
        local st = (State.ESPReiatsu or State.ESPPosture or State.ESPStamina or State.ESPStates)
            and char:FindFirstChild("Status") or nil
        local lines
        if st then
            if State.ESPReiatsu then
                local o = st:FindFirstChild("Reiatsu")
                if o then lines = lines or {}; lines[#lines+1] = ("Reiatsu %d"):format(math.floor(o.Value + 0.5)) end
            end
            if State.ESPPosture then
                local o = st:FindFirstChild("Posture")
                if o then
                    local mx = (o:IsA("DoubleConstrainedValue") and o.MaxValue) or 0
                    lines = lines or {}
                    if mx > 0 then lines[#lines+1] = ("Posture %d%%"):format(math.floor(o.Value / mx * 100 + 0.5))
                    else lines[#lines+1] = ("Posture %d"):format(math.floor(o.Value + 0.5)) end
                end
            end
            if State.ESPStamina then
                local o = st:FindFirstChild("ShunpoStamina")
                if o then lines = lines or {}; lines[#lines+1] = ("Stamina %d"):format(math.floor(o.Value + 0.5)) end
            end
            if State.ESPStates then
                local active
                for _, sn in ipairs(ESP_STATE_NAMES) do
                    local o = st:FindFirstChild(sn)
                    if o and o.Value and o.Value > 0 then active = active or {}; active[#active+1] = sn end
                end
                if active then lines = lines or {}; lines[#lines+1] = table.concat(active, " · ") end
            end
        end
        if State.ESPRaceForm then
            local race = getRace(char)
            if race then lines = lines or {}; lines[#lines+1] = race .. (char:GetAttribute("IsBoss") and "  [BOSS]" or "") end
        end
        if lines then
            txt.stats.Text = table.concat(lines, "\n"); txt.stats.Visible = true
        else
            txt.stats.Visible = false
        end
    end
    outlineFor(char, color)
    hitboxFor(root, char)
    -- 2D box + side bar track the same target (color + health fraction).
    if State.ESPBox then
        local b = boxFor(root)
        if b then
            b.color = color
            b.frac = (hum and hum.MaxHealth and hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 1
        end
    else
        removeBox(root)
    end
    -- No Persistent ESP: allow the character model to stream out normally.
    if State.NoPersistentESP then
        pcall(function() char.ModelStreamingMode = Enum.ModelStreamingMode.Default end)
    end
end

local function destroyPair(pair)
    if not pair then return end
    if pair.text then pcall(function() pair.text:Destroy() end) end
    if pair.hp   then pcall(function() pair.hp:Destroy()   end) end
end

function Visuals.clearESP()
    for _, pair in pairs(espTags) do destroyPair(pair) end
    for c, hl in pairs(espHL) do if hl then pcall(function() hl:Destroy() end) end end
    for r, hb in pairs(espHB) do if hb then pcall(function() hb:Destroy() end) end end
    for r in pairs(espBox) do removeBox(r) end
    espTags = {}; espHL = {}; espHB = {}
end

-- Smooth per-frame box positioner.
local boxAccum = 0
Conns.add(RunService.RenderStepped:Connect(function(dt)
    if not DrawingLib then return end
    local on = State and State.ESP and State.ESPBox
    if not on then
        for _, b in pairs(espBox) do b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false end
        return
    end
    boxAccum = boxAccum + (dt or 0)         -- throttle to ~30 Hz (boxes don't need 60+)
    if boxAccum < 1/30 then return end
    boxAccum = 0
    local cam = workspace.CurrentCamera; if not cam then return end
    for root, b in pairs(espBox) do
        if root and root.Parent then
            local cf = root.CFrame
            local tv = cam:WorldToViewportPoint((cf * CFrame.new(0,  2.8, 0)).Position)
            local bv = cam:WorldToViewportPoint((cf * CFrame.new(0, -3.2, 0)).Position)
            if tv.Z > 0 and bv.Z > 0 then
                local h = math.abs(bv.Y - tv.Y)
                local w = h * 0.62
                local x = (tv.X + bv.X) * 0.5 - w * 0.5
                local y = math.min(tv.Y, bv.Y)
                b.box.Size = Vector2.new(w, h); b.box.Position = Vector2.new(x, y)
                b.box.Color = b.color or COL_PLAYER; b.box.Visible = true
                if State.ESPBoxBar and State.ESPHealth ~= false then
                    local frac = math.clamp(b.frac or 1, 0, 1)
                    local bx = x - 5
                    b.barbg.Size = Vector2.new(3, h); b.barbg.Position = Vector2.new(bx, y); b.barbg.Visible = true
                    local bh = h * frac
                    b.bar.Size = Vector2.new(3, bh); b.bar.Position = Vector2.new(bx, y + (h - bh))
                    b.bar.Color = Color3.fromRGB(math.floor(255*(1-frac)), math.floor(210*frac), 70)
                    b.bar.Visible = true
                else
                    b.barbg.Visible=false; b.bar.Visible=false
                end
            else
                b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false
            end
        else
            b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false
        end
    end
end))

-- Name-based overrides (lowercase substring match):
--  ESP_IGNORE  -> never tagged at all (e.g. the training dummy)
--  ESP_AS_NPC  -> always classified as NPC regardless of prompts
local ESP_IGNORE = { "dummy", "training" }
local ESP_AS_NPC = { "swordretrieve" }
local function nameMatches(name, list)
    local n = (name or ""):lower()
    for _, k in ipairs(list) do if n:find(k, 1, true) then return true end end
    return false
end
local function isIgnored(char) return nameMatches(char.Name, ESP_IGNORE) end

-- Classify a non-player character: NPC (has ProximityPrompt / "NPC" tag) vs Mob.
-- Result is cached per character — walking GetDescendants() every tick was the
-- single biggest ESP cost on busy servers. Cache is purged automatically when
-- the character leaves the tag dictionary (see clearESP / cull loop).
local classifyCache = setmetatable({}, { __mode = "k" })
local function classify(char)
    local hit = classifyCache[char]
    if hit then return hit[1], hit[2] end
    local kind, col = "MOB", COL_MOB
    if nameMatches(char.Name, ESP_AS_NPC) then
        kind, col = "NPC", COL_NPC
    else
        for _, ch in ipairs(char:GetDescendants()) do
            if ch:IsA("ProximityPrompt") then kind, col = "NPC", COL_NPC; break end
        end
        if kind == "MOB" and (char:GetAttribute("NPC") or char:FindFirstChild("IsNPC")) then
            kind, col = "NPC", COL_NPC
        end
    end
    classifyCache[char] = { kind, col }
    return kind, col
end

do
    local lastTick = 0
    -- Reused buffer tables; clearing-and-refilling avoids per-tick allocations.
    local playerCharSet = {}
    local seen = {}
    local elig = {}            -- this-tick allowed targets (split-frame slicing)
    local splitPart = 0        -- rotating slice index for ESP Split Updates
    Conns.add(RunService.Heartbeat:Connect(function()
        if not State or not State.ESP then return end
        local now = tick()
        -- ESP Limit Updates + Refresh Rate (deepwoken-style throttle). When the
        -- limiter is on, cap updates to ESPRefreshRate per second; off = every
        -- Heartbeat. Default 30/s (was a fixed 5 Hz).
        if State.ESPLimitUpdates ~= false then
            local rate = State.ESPRefreshRate or 30; if rate < 1 then rate = 1 end
            if now - lastTick < 1 / rate then return end
        end
        lastTick = now
        local _, me = getCharParts(); if not me then return end
        local myPos = me.Position
        -- Squared-distance compare avoids the sqrt inside Magnitude.
        local range  = State.ESPRange
        local range2 = range * range
        -- Per-tick budget for CREATING new ESP objects. Moving into a crowd used
        -- to spawn dozens of BillboardGuis + Highlights in one frame (Highlights
        -- are heavy to instantiate) -> a lag spike. Cap new creations per tick so
        -- they amortise over a few ticks. Already-tagged entities still update
        -- every tick, so nothing visible changes except a slight stagger on appear.
        local newBudget = 8

        -- Cull tags out of range / gone
        for root, pair in pairs(espTags) do
            if not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                destroyPair(pair)
                espTags[root] = nil
            end
        end
        -- Cull hitbox boxes out of range / gone / disabled
        for root, hb in pairs(espHB) do
            if not State.ESPHitbox or not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                if hb then pcall(function() hb:Destroy() end) end
                espHB[root] = nil
            end
        end
        -- Cull highlights for gone / out-of-range characters
        for char, hl in pairs(espHL) do
            local r = char and (char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChildWhichIsA("BasePart"))
            if not char or not char.Parent or not r
                or (r.Position - myPos).Magnitude > range then
                if hl then pcall(function() hl:Destroy() end) end
                espHL[char] = nil
            end
        end
        -- Cull 2D boxes out of range / gone / disabled
        for root in pairs(espBox) do
            if not State.ESPBox or not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                removeBox(root)
            end
        end

        -- Reuse buffers
        for k in pairs(playerCharSet) do playerCharSet[k] = nil end
        for k in pairs(seen) do seen[k] = nil end
        local plist = Players:GetPlayers()
        for i = 1, #plist do
            local p = plist[i]; local c = p.Character
            if c then playerCharSet[c] = p end
        end

        -- PASS 1 — discover allowed targets into `elig` and clean up filtered ones.
        -- (Cheap per-target work every tick; the heavy tag update is PASS 2.)
        local nElig = 0
        for d in Humanoids.iter() do
            if d.Health > 0 then
                local c = d.Parent
                if c and c ~= LP.Character and not seen[c] then
                    seen[c] = true
                    local r = c:FindFirstChild("HumanoidRootPart")
                        or c:FindFirstChildWhichIsA("BasePart")
                    if r then
                        local off = r.Position - myPos
                        local d2  = off.X*off.X + off.Y*off.Y + off.Z*off.Z
                        if d2 <= range2 then
                            -- Resolve kind first so per-type filters can skip it.
                            local plr = playerCharSet[c]
                            local kind, col, nm
                            if plr then
                                kind, col, nm = "PLAYER", COL_PLAYER, (plr.DisplayName or plr.Name)
                            else
                                kind, col = classify(c); nm = bestName(c, d)
                            end
                            local allowed =
                                  (kind == "PLAYER" and State.ESPPlayers ~= false)
                               or (kind == "NPC"    and State.ESPNPCs    ~= false)
                               or (kind == "MOB"    and State.ESPMobs    ~= false)
                            -- Never tag ignored characters (training dummy, etc).
                            if not plr and isIgnored(c) then allowed = false end
                            if allowed then
                                nElig = nElig + 1
                                local e = elig[nElig]
                                if not e then e = {}; elig[nElig] = e end
                                e.r, e.c, e.nm, e.kind, e.col, e.hum, e.dist =
                                    r, c, nm, kind, col, d, math.sqrt(d2)
                            else
                                -- Filtered out: drop any tag/outline/box it had.
                                local pair = espTags[r]
                                if pair then destroyPair(pair); espTags[r] = nil end
                                local hl = espHL[c]
                                if hl then pcall(function() hl:Destroy() end); espHL[c] = nil end
                                removeBox(r)
                            end
                        end
                    end
                end
            end
        end

        -- ESP Max Targets: render only the nearest N (0 = unlimited). Farther
        -- in-range targets get their tag/outline/box removed so nothing lingers.
        local total = nElig
        local cap = State.ESPMaxTargets or 0
        if cap > 0 and total > cap then
            table.sort(elig, function(a, b)
                local ad = (a and a.r) and (a.dist or 1e9) or math.huge
                local bd = (b and b.r) and (b.dist or 1e9) or math.huge
                return ad < bd
            end)
            for i = cap + 1, total do
                local e = elig[i]
                if e and e.r then
                    local pair = espTags[e.r]; if pair then destroyPair(pair); espTags[e.r] = nil end
                    if e.c then local hl = espHL[e.c]; if hl then pcall(function() hl:Destroy() end); espHL[e.c] = nil end end
                    removeBox(e.r)
                end
            end
            nElig = cap
        end

        -- PASS 2 — update tags. Normally every eligible target; with Split
        -- Updates on, only a rotating 1/ESPSplitFrames slice per tick (the rest
        -- keep their last tag, so the heavy work spreads across frames). New
        -- targets still obey the per-tick creation budget.
        local lo, hi = 1, nElig
        if State.ESPSplitUpdates and nElig > 0 then
            local frames = State.ESPSplitFrames or 3; if frames < 1 then frames = 1 end
            local per = math.ceil(nElig / frames)
            splitPart = (splitPart % frames) + 1
            lo = (splitPart - 1) * per + 1
            hi = math.min(splitPart * per, nElig)
        end
        for i = lo, hi do
            local e = elig[i]
            if e and e.r then
                local isNew = espTags[e.r] == nil
                if not (isNew and newBudget <= 0) then
                    if isNew then newBudget = newBudget - 1 end
                    local ok, err = pcall(updateTag, e.r, e.c, e.nm, e.kind, e.col, e.hum, e.dist)
                    if not ok then _G.__espErr = tostring(err) end
                end
            end
        end
        -- Release references so culled characters can be collected.
        for i = 1, total do local e = elig[i]; if e then e.c, e.r, e.hum, e.nm = nil, nil, nil, nil end end
    end))
end
function Visuals.setESP(v) State.ESP = v; if not v then Visuals.clearESP() end end
function Visuals.setESPOutline(v)
    State.ESPOutline = v
    if not v then for c, hl in pairs(espHL) do if hl then pcall(function() hl:Destroy() end) end end; espHL = {} end
end

-- AnimationVisualizer panel parent helpers (kept for compatibility)
local animParent
function Visuals.setAnimParent(p)     animParent = p end
function Visuals.setCrosshairParent() end
function Visuals.setFPSParent()       end
function Visuals.setAnimVis()         end -- inline disabled; use the DW visualizer

--==============================================================
-- FULLBRIGHT
--==============================================================
local origLighting
function Visuals.setFullbright(on)
    State.Fullbright = on
    if on then
        origLighting = origLighting or {
            B  = Lighting.Brightness, A  = Lighting.Ambient, OA = Lighting.OutdoorAmbient,
            CB = Lighting.ColorShift_Bottom, CT = Lighting.ColorShift_Top,
            GS = Lighting.GlobalShadows,
        }
        Lighting.Brightness        = 2
        Lighting.Ambient           = Color3.fromRGB(178,178,178)
        Lighting.OutdoorAmbient    = Color3.fromRGB(178,178,178)
        Lighting.ColorShift_Bottom = Color3.fromRGB(178,178,178)
        Lighting.ColorShift_Top    = Color3.fromRGB(178,178,178)
        Lighting.GlobalShadows     = false
    elseif origLighting then
        Lighting.Brightness        = origLighting.B
        Lighting.Ambient           = origLighting.A
        Lighting.OutdoorAmbient    = origLighting.OA
        Lighting.ColorShift_Bottom = origLighting.CB
        Lighting.ColorShift_Top    = origLighting.CT
        Lighting.GlobalShadows     = origLighting.GS
    end
end

--==============================================================
-- PERFORMANCE / VISUAL REMOVALS — the EXACT set deepwoken-rewrite removes,
-- exposed both as individual toggles AND bundled under "Performance Mode".
--   No Fog          : Lighting.FogStart/FogEnd = 9e9 ; every Atmosphere.Density = 0
--   No Blur         : every BlurEffect.Size = 0
--   No Shadows      : Lighting.GlobalShadows = false
--   No Animated Sea : disable the "SeaClient" container + its LocalScripts
-- Each setter snapshots originals into its own table and restores on toggle-off.
--==============================================================

-- No Shadows -------------------------------------------------
local shadowsOrig
function Visuals.setNoShadows(on)
    State.NoShadows = on
    if on then
        if shadowsOrig == nil then shadowsOrig = Lighting.GlobalShadows end
        pcall(function() Lighting.GlobalShadows = false end)
    else
        if shadowsOrig ~= nil then
            pcall(function() Lighting.GlobalShadows = shadowsOrig end); shadowsOrig = nil
        end
    end
end

-- No Fog -----------------------------------------------------
local noFogConn, noFogOrig, fogOrig = nil, {}, nil
local function noFogApply(inst)
    if inst:IsA("Atmosphere") then
        if noFogOrig[inst] == nil then noFogOrig[inst] = inst.Density end
        pcall(function() inst.Density = 0 end)
    end
end
function Visuals.setNoFog(on)
    State.NoFog = on
    if on then
        if fogOrig == nil then fogOrig = { FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd } end
        pcall(function() Lighting.FogStart = 9e9; Lighting.FogEnd = 9e9 end)
        for _, d in ipairs(Lighting:GetDescendants()) do noFogApply(d) end
        if not noFogConn then noFogConn = Conns.add(Lighting.DescendantAdded:Connect(noFogApply)) end
    else
        if noFogConn then noFogConn:Disconnect(); noFogConn = nil end
        if fogOrig then
            pcall(function() Lighting.FogStart = fogOrig.FogStart; Lighting.FogEnd = fogOrig.FogEnd end)
            fogOrig = nil
        end
        for inst, v in pairs(noFogOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Density = v end) end
        end
        noFogOrig = {}
    end
end

-- No Blur ----------------------------------------------------
local noBlurConn, noBlurOrig = nil, {}
local function noBlurApply(inst)
    if inst:IsA("BlurEffect") then
        if noBlurOrig[inst] == nil then noBlurOrig[inst] = inst.Size end
        pcall(function() inst.Size = 0 end)
    end
end
function Visuals.setNoBlur(on)
    State.NoBlur = on
    if on then
        for _, d in ipairs(Lighting:GetDescendants()) do noBlurApply(d) end
        for _, d in ipairs(workspace:GetDescendants()) do noBlurApply(d) end
        if not noBlurConn then
            noBlurConn = Conns.add(Lighting.DescendantAdded:Connect(noBlurApply))
            Conns.add(workspace.DescendantAdded:Connect(noBlurApply))
        end
    else
        if noBlurConn then noBlurConn:Disconnect(); noBlurConn = nil end
        for inst, v in pairs(noBlurOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Size = v end) end
        end
        noBlurOrig = {}
    end
end

-- No Animated Sea --------------------------------------------
local noSeaConn, noSeaOrig = nil, {}
local function noSeaApply(inst)
    if inst.Name == "SeaClient" then
        if noSeaOrig[inst] == nil then noSeaOrig[inst] = inst.Enabled end
        pcall(function() inst.Enabled = false end)
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("LocalScript") then
                if noSeaOrig[d] == nil then noSeaOrig[d] = d.Enabled end
                pcall(function() d.Enabled = false end)
            end
        end
    end
end
function Visuals.setNoAnimatedSea(on)
    State.NoAnimatedSea = on
    if on then
        for _, d in ipairs(workspace:GetDescendants()) do noSeaApply(d) end
        if not noSeaConn then noSeaConn = Conns.add(workspace.DescendantAdded:Connect(noSeaApply)) end
    else
        if noSeaConn then noSeaConn:Disconnect(); noSeaConn = nil end
        for inst, v in pairs(noSeaOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Enabled = v end) end
        end
        noSeaOrig = {}
    end
end

-- Performance Mode (master) — flips all four together.
function Visuals.setLowGfx(on)
    State.LowGfx = on
    Visuals.setNoFog(on)
    Visuals.setNoBlur(on)
    Visuals.setNoShadows(on)
    Visuals.setNoAnimatedSea(on)
end

-- Keep Performance Mode removals applied when the GAME changes them — e.g. moving to
-- a new zone re-enables shadows/fog. The one-shot setters + DescendantAdded only catch
-- NEW instances; these handle the Lighting PROPERTIES being reset (GlobalShadows / Fog),
-- plus a light periodic re-apply of Lighting descendants in case an EXISTING atmosphere/
-- blur is changed rather than re-added. Event-driven, so no cost while nothing changes.
local function setupPerfPersistence()
    Conns.add(Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
        if State.NoShadows and Lighting.GlobalShadows ~= false then
            pcall(function() Lighting.GlobalShadows = false end)
        end
    end))
    local function reFog()
        if State.NoFog then pcall(function() Lighting.FogStart = 9e9; Lighting.FogEnd = 9e9 end) end
    end
    Conns.add(Lighting:GetPropertyChangedSignal("FogStart"):Connect(reFog))
    Conns.add(Lighting:GetPropertyChangedSignal("FogEnd"):Connect(reFog))
    -- Safety net: ~every 2s re-apply the cheap Lighting-level removals (small scan, only
    -- when something is on) to catch existing-instance changes a new area might make.
    local lastT = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if not (State.NoFog or State.NoBlur or State.NoShadows) then return end
        local now = os.clock(); if now - lastT < 2 then return end; lastT = now
        if State.NoShadows then pcall(function() Lighting.GlobalShadows = false end) end
        if State.NoFog then pcall(function() Lighting.FogStart = 9e9; Lighting.FogEnd = 9e9 end) end
        for _, d in ipairs(Lighting:GetDescendants()) do
            if State.NoFog and d:IsA("Atmosphere") then pcall(function() d.Density = 0 end)
            elseif State.NoBlur and d:IsA("BlurEffect") then pcall(function() d.Size = 0 end) end
        end
    end))
end

function Visuals.init(state)
    State = state
    setupPerfPersistence()
    Conns.onTeardown(function()
        Visuals.setFullbright(false); Visuals.setLowGfx(false); Visuals.clearESP()
    end)
end
return Visuals

end)
__bundle_register("Features/Movement", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Movement: Toggle Sprint, Fly, Noclip. Nothing else.
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local VIM        = game:GetService("VirtualInputManager")
local Players    = game:GetService("Players")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")

local Movement = {}
local State

--==============================================================
-- TOGGLE SPRINT (holds Shift via VIM)
--==============================================================
function Movement.setSprint(on)
    State.ToggleSprint = on
    pcall(function() VIM:SendKeyEvent(on, Enum.KeyCode.LeftShift, false, game) end)
end

--==============================================================
-- FLY
--==============================================================
local flyBV, flyBG, flyConn
function Movement.stopFly()
    State.Fly = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    local _,_,h = getCharParts(); if h then h.PlatformStand = false end
end
function Movement.startFly()
    local _,hrp,h = getCharParts(); if not hrp or not h then return end
    State.Fly = true; h.PlatformStand = true
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5); flyBV.Velocity = Vector3.new(); flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBG.P = 1e4; flyBG.Parent = hrp
    flyConn = Conns.add(RunService.Heartbeat:Connect(function()
        local _,r,hh = getCharParts()
        if not r or not hh or r ~= hrp then Movement.stopFly() return end
        local cam = workspace.CurrentCamera
        local v = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then v = v + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then v = v - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then v = v - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then v = v + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then v = v + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - Vector3.new(0,1,0) end
        flyBV.Velocity = v * State.FlySpeed
        if v.Magnitude > 0 then flyBG.CFrame = cam.CFrame end
    end))
end
function Movement.setFly(v) if v then Movement.startFly() else Movement.stopFly() end end

--==============================================================
-- NOCLIP
--==============================================================
local noclipConn, noclipAddConn, noclipCharConn
local origCollide = {}
local cachedParts = {}                      -- char -> { BasePart, ... }
local function rebuildPartCache(c)
    if not c then return end
    local list = {}
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then list[#list+1] = p end
    end
    cachedParts[c] = list
end
function Movement.setNoclip(on)
    State.Noclip = on
    if noclipConn       then noclipConn:Disconnect();       noclipConn       = nil end
    if noclipAddConn    then noclipAddConn:Disconnect();    noclipAddConn    = nil end
    if noclipCharConn   then noclipCharConn:Disconnect();   noclipCharConn   = nil end
    if on then
        -- Build the cache once; refresh only when parts are added/removed.
        local function bindChar(c)
            if not c then return end
            rebuildPartCache(c)
            noclipAddConn = Conns.add(c.DescendantAdded:Connect(function(p)
                if p:IsA("BasePart") then
                    local list = cachedParts[c]; if list then list[#list+1] = p end
                end
            end))
        end
        bindChar(LP.Character)
        noclipCharConn = Conns.add(LP.CharacterAdded:Connect(bindChar))
        noclipConn = Conns.add(RunService.Stepped:Connect(function()
            local c = LP.Character; if not c then return end
            local list = cachedParts[c]
            if not list then rebuildPartCache(c); list = cachedParts[c] end
            for i = 1, #list do
                local p = list[i]
                if p.Parent then
                    if origCollide[p] == nil then origCollide[p] = p.CanCollide end
                    if p.CanCollide then p.CanCollide = false end
                end
            end
        end))
    else
        for p, orig in pairs(origCollide) do
            if p and p.Parent then pcall(function() p.CanCollide = orig end) end
        end
        origCollide = {}
        for k in pairs(cachedParts) do cachedParts[k] = nil end
    end
end

--==============================================================
-- TWEEN TO BACK — smoothly slide the player to a point BEHIND the nearest enemy
-- (offset distance + height, facing them), and hold there. Noclips while moving.
-- Ported from the deepwoken reference's "Tween To Back".
--==============================================================
local Humanoids = require("Utility/Humanoids")
local ttbConn
local ttbCached                              -- sticky target (a character Model)
local ttbCollideOrig = {}                    -- BasePart -> original CanCollide
local ttbParts = setmetatable({}, { __mode = "k" })  -- char -> cached BasePart list

local function ttbRestoreCollide()
    for p, orig in pairs(ttbCollideOrig) do
        if p and p.Parent then pcall(function() p.CanCollide = orig end) end
    end
    ttbCollideOrig = {}
end
-- Lightweight noclip on the body parts while tweening. The BasePart list is
-- cached per character (weak-keyed), so we don't allocate a GetChildren() table
-- (or re-run IsA on every part) each frame while attached.
local function ttbNoclip(char)
    local list = ttbParts[char]
    if not list then
        list = {}
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then list[#list + 1] = p end
        end
        ttbParts[char] = list
    end
    for i = 1, #list do
        local p = list[i]
        if p.Parent and p.CanCollide then
            if ttbCollideOrig[p] == nil then ttbCollideOrig[p] = p.CanCollide end
            p.CanCollide = false
        end
    end
end

-- A character is a live attach candidate: exists, isn't us, has a Humanoid with
-- health, and has an HRP. (Position sanity is covered by the range check.)
local function ttbAlive(c)
    if not (c and c.Parent and c ~= LP.Character) then return false end
    local h = c:FindFirstChildWhichIsA("Humanoid")
    if not (h and h.Health > 0) then return false end
    return c:FindFirstChild("HumanoidRootPart") ~= nil
end
-- Type filters applied when PICKING a fresh target.
local function ttbAllowed(c)
    if State.TTBIgnorePlayers and Players:GetPlayerFromCharacter(c) then return false end
    if c:GetAttribute("NPC") or c:FindFirstChild("IsNPC") then return false end   -- skip dialogue NPCs
    return true
end

-- Nearest allowed, living enemy within range.
local function ttbNearest()
    local _, me = getCharParts()
    if not me then return nil end
    local myPos = me.Position
    local range = State.TTBRange or 300
    local best, bd
    for hum in Humanoids.iter() do
        if hum.Health > 0 then
            local c = hum.Parent
            if c and ttbAlive(c) and ttbAllowed(c) then
                local r = c:FindFirstChild("HumanoidRootPart")
                local d = (r.Position - myPos).Magnitude
                if d <= range and (not bd or d < bd) then bd = d; best = c end
            end
        end
    end
    return best
end

-- Hold the current target instead of re-picking every frame (stops flip-flopping
-- between enemies). Sticky = hold until it dies; otherwise hold while it's in range.
local function ttbKeep(c)
    if not ttbAlive(c) then return false end
    if State.TTBSticky then return true end
    local _, me = getCharParts()
    local r = c:FindFirstChild("HumanoidRootPart")
    return (me and r and (r.Position - me.Position).Magnitude <= (State.TTBRange or 300)) or false
end

local function ttbStep(dt)
    if not State or not State.TweenToBack then return end
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Hold the current target while it's still good; otherwise pick the nearest.
    local target
    if ttbCached and ttbKeep(ttbCached) then
        target = ttbCached
    else
        target = ttbNearest(); ttbCached = target
    end
    if not target then ttbRestoreCollide(); return end

    local thrp = target:FindFirstChild("HumanoidRootPart")
    if not thrp then ttbRestoreCollide(); return end

    -- Goal = a point behind the target (+Z local is behind it).
    local goalPos = (thrp.CFrame * CFrame.new(0, State.TTBHeight or 0, State.TTBDistance or 5)).Position

    ttbNoclip(char)

    -- Slide toward the goal at TTBSpeed studs/sec (smooth 3D — no Y snapping).
    local startPos = hrp.Position
    local toGoal   = goalPos - startPos
    local dist     = toGoal.Magnitude
    local newPos
    if dist < 0.01 then
        newPos = goalPos
    else
        local stepD = (State.TTBSpeed or 200) * dt
        newPos = (stepD >= dist) and goalPos or (startPos + toGoal.Unit * stepD)
    end

    -- Face the target by YAW ONLY — a horizontal look can never be a NaN CFrame,
    -- which is what flung the character to the void before.
    local flat = Vector3.new(thrp.Position.X - newPos.X, 0, thrp.Position.Z - newPos.Z)
    if flat.Magnitude > 0.001 then
        hrp.CFrame = CFrame.lookAt(newPos, newPos + flat)
    else
        hrp.CFrame = CFrame.new(newPos)
    end
end

function Movement.setTweenToBack(on)
    State.TweenToBack = on
    if ttbConn then ttbConn:Disconnect(); ttbConn = nil end
    ttbCached = nil
    if on then
        ttbConn = Conns.add(RunService.Heartbeat:Connect(ttbStep))
    else
        ttbRestoreCollide()
    end
end

-- Respawn safety
Conns.add(LP.CharacterAdded:Connect(function(char)
    if State and State.Fly then Movement.stopFly() end
    if State and State.ToggleSprint then Movement.setSprint(false) end
    ttbCollideOrig = {}; ttbCached = nil          -- old parts are gone
end))

function Movement.init(state)
    State = state
    -- One-time heal: a previous build could leave a character with Landed /
    -- FallingDown disabled (constant falling). Re-enable them on every load.
    pcall(function()
        local hum = LP.Character and LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end)
    Conns.onTeardown(function()
        Movement.stopFly(); Movement.setNoclip(false); ttbRestoreCollide()
        pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end)
    end)
end
return Movement

end)
__bundle_register("Features/ParryTimings", function(require, _LOADED, __bundle_register, __bundle_modules)
-- ParryTimings: per-animation impact-time table with metadata.
--
-- Storage format (parrytimings.json):
--   { [animId] = { sec = number, cat = string?, note = string?, src = "manual"|"learned"|"kf" } }
-- Old flat format ({ [animId] = number }) is auto-migrated on load.
local Http = game:GetService("HttpService")

local ParryTimings = {}
local timings = {}
local FILE = "parrytimings.json"

-- Each entry now holds arrays of parry times + dodge times:
--   { sec=<times[1] mirror>, times={t1,t2,...}, dodges={d1,...}, cat, src, note }
-- `sec` stays in sync with times[1] for any old code/UI that reads it.
local function syncSec(e)
    e.sec = (e.times and e.times[1]) or e.sec
end
local function migrate()
    for id, v in pairs(timings) do
        if type(v) == "number" then
            timings[id] = { sec = v, times = { v }, dodges = {}, cat = "Uncategorized", src = "learned" }
        elseif type(v) == "table" then
            v.cat = v.cat or "Uncategorized"
            v.src = v.src or "manual"
            if type(v.times) ~= "table" then
                v.times = (type(v.sec) == "number") and { v.sec } or {}
            end
            if type(v.dodges) ~= "table" then v.dodges = {} end
            syncSec(v)
        end
    end
end

local function load()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then timings = t end
    end
    migrate()
end

-- Bumps on every mutation so UIs (Timings tab) can auto-refresh when timings
-- change from ANY source (manual edit, Animation Visualizer, Player Timing…).
ParryTimings.rev = 0
local function save()
    ParryTimings.rev = ParryTimings.rev + 1
    pcall(function() writefile(FILE, Http:JSONEncode(timings)) end)
end

-- Distill AutoParryData entries into the table, preserving existing manual ones.
function ParryTimings.generate()
    local apd = _G.__AutoParryData
    if not apd or not apd.all then return 0 end
    local n = 0
    for id, e in pairs(apd.all()) do
        local cur = timings[id]
        if not cur or cur.src ~= "manual" then
            local sec
            local src
            if type(e.kfImpact) == "number" then
                sec = e.kfImpact; src = "kf"
            elseif type(e.calEma) == "number" and (e.calSamples or 0) >= 1 then
                sec = e.calEma; src = "calibration"
            elseif type(e.ema) == "number" then
                sec = e.ema; src = "learned"
            elseif type(e.avg) == "number" and e.avg > 0 then
                sec = e.avg; src = "learned"
            end
            if sec and sec >= 0.05 and sec <= 4.0 then
                timings[id] = { sec = sec, times = { sec },
                    dodges = (cur and cur.dodges) or {},
                    cat = (cur and cur.cat) or "Uncategorized", src = src }
                n = n + 1
            end
        end
    end
    save()
    return n
end

-- Returns the FIRST parry time (compat). Use getTimes for the full list.
function ParryTimings.lookup(animId)
    local v = timings[animId]
    if not v then return nil end
    if type(v) == "number" then return v end
    return (v.times and v.times[1]) or v.sec
end

-- Full lists. Always return a (possibly empty) array.
function ParryTimings.getTimes(animId)
    local v = timings[animId]
    if type(v) ~= "table" then
        return (type(v) == "number") and { v } or {}
    end
    return v.times or {}
end
function ParryTimings.getDodges(animId)
    local v = timings[animId]
    return (type(v) == "table" and v.dodges) or {}
end

local function ensureEntry(id, cat)
    local e = timings[id]
    if type(e) ~= "table" then
        e = { times = {}, dodges = {}, cat = cat or "Uncategorized", src = "manual" }
        timings[id] = e
    end
    e.times  = e.times  or {}
    e.dodges = e.dodges or {}
    if cat then e.cat = cat end
    return e
end
local function insertSorted(list, sec)
    -- avoid near-duplicates (within 10ms)
    for _, t in ipairs(list) do if math.abs(t - sec) < 0.01 then return false end end
    table.insert(list, sec)
    table.sort(list)
    return true
end

-- Append a parry time (multi-hit attacks can have several).
function ParryTimings.addParry(animId, seconds, cat)
    if not animId or animId == "" or type(seconds) ~= "number" then return false end
    local e = ensureEntry(tostring(animId), cat)
    local added = insertSorted(e.times, seconds)
    e.src = "manual"; syncSec(e); save()
    return added
end
-- Append a dodge time.
function ParryTimings.addDodge(animId, seconds, cat)
    if not animId or animId == "" or type(seconds) ~= "number" then return false end
    local e = ensureEntry(tostring(animId), cat)
    local added = insertSorted(e.dodges, seconds)
    e.src = "manual"; save()
    return added
end
-- Replace the parry time at index `idx` with a new value (keeps category).
-- Re-sorts afterwards so the list stays ordered. Returns true on success.
function ParryTimings.setParryAt(animId, idx, seconds)
    if type(seconds) ~= "number" then return false end
    local e = timings[animId]
    if type(e) == "table" and e.times and e.times[idx] then
        e.times[idx] = math.max(seconds, 0)
        table.sort(e.times)
        e.src = "manual"; syncSec(e); save()
        return true
    end
    return false
end
function ParryTimings.removeParryAt(animId, idx)
    local e = timings[animId]
    if type(e) == "table" and e.times and e.times[idx] then
        table.remove(e.times, idx); syncSec(e)
        if #e.times == 0 and #(e.dodges or {}) == 0 then timings[animId] = nil end
        save()
    end
end
function ParryTimings.removeDodgeAt(animId, idx)
    local e = timings[animId]
    if type(e) == "table" and e.dodges and e.dodges[idx] then
        table.remove(e.dodges, idx)
        if #(e.times or {}) == 0 and #e.dodges == 0 then timings[animId] = nil end
        save()
    end
end
-- Replace the dodge time at index `idx` with a new value (keeps the list sorted).
function ParryTimings.setDodgeAt(animId, idx, seconds)
    if type(seconds) ~= "number" then return false end
    local e = timings[animId]
    if type(e) == "table" and e.dodges and e.dodges[idx] then
        e.dodges[idx] = math.max(seconds, 0)
        table.sort(e.dodges)
        e.src = "manual"; save()
        return true
    end
    return false
end

function ParryTimings.all() return timings end
function ParryTimings.count()
    local c = 0; for _ in pairs(timings) do c = c + 1 end; return c
end

-- Mutators
-- Sets the PRIMARY parry time (times[1]); keeps any extra times + dodges.
function ParryTimings.set(animId, seconds, cat, note)
    if not animId or animId == "" or type(seconds) ~= "number" then return end
    local id = tostring(animId)
    local e = ensureEntry(id, cat)
    if e.times[1] then e.times[1] = seconds else table.insert(e.times, seconds) end
    table.sort(e.times)
    if note then e.note = note end
    e.src = "manual"; syncSec(e); save()
end
function ParryTimings.setCategory(animId, cat)
    local v = timings[animId]
    if type(v) ~= "table" then return end
    v.cat = cat or "Uncategorized"
    save()
end
function ParryTimings.setNote(animId, note)
    local v = timings[animId]
    if type(v) ~= "table" then return end
    v.note = note
    save()
end
function ParryTimings.remove(animId)
    timings[tostring(animId)] = nil; save()
end
function ParryTimings.clear() timings = {}; save() end

-- Remove every timing belonging to one category. Returns count removed.
function ParryTimings.clearCategory(cat)
    if not cat or cat == "" then return 0 end
    local n = 0
    for id, v in pairs(timings) do
        local c = (type(v) == "table" and (v.cat or "Uncategorized")) or "Uncategorized"
        if c == cat then timings[id] = nil; n = n + 1 end
    end
    if n > 0 then save() end
    return n
end

-- Category helpers
function ParryTimings.categories()
    local seen, list = {}, {}
    for _, v in pairs(timings) do
        local c = (type(v) == "table" and v.cat) or "Uncategorized"
        if not seen[c] then seen[c] = true; table.insert(list, c) end
    end
    table.sort(list)
    return list
end

-- Export / Import (clipboard-friendly JSON)
function ParryTimings.export()
    local json = Http:JSONEncode(timings)
    local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if cb then pcall(cb, json) end
    return json
end
function ParryTimings.import(json)
    local ok, t = pcall(function() return Http:JSONDecode(json) end)
    if not ok or type(t) ~= "table" then return false, "bad JSON" end
    for k, v in pairs(t) do timings[tostring(k)] = v end
    migrate(); save()
    return true, "imported"
end

function ParryTimings.init() load() end

-- Load immediately at require-time so saved timings exist before anything
-- (Main, AutoParry, the menu) reads them. Prevents accidental overwrite.
load()

return ParryTimings

end)
__bundle_register("Features/AutoParryData", function(require, _LOADED, __bundle_register, __bundle_modules)
-- AutoParryData: passively learns enemy attack timings.
-- How it works:
--   For every nearby enemy humanoid track that starts, we record { hum, startClock }.
--   When the LocalPlayer's Humanoid takes a health drop, we look at every active
--   enemy track and credit the closest one (most recent start) as the attack.
--   We store { anim_id -> { samples=int, avgImpact=secs, minImpact, maxImpact } }.
--   Persisted to "__autoparry.json".
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpSvc    = game:GetService("HttpService")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local getCharParts = require("Utility/Char")
local Humanoids  = require("Utility/Humanoids")

local AutoParryData = {}
local State

-- Persistent learned data: id -> {samples, sum, min, max, last}
local data = {}
local FILE = "__autoparry.json"

-- Active enemy tracks: hum -> { [animId] = startClock }
local active = setmetatable({}, { __mode = "k" })

local function loadData()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return HttpSvc:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then data = t end
    end
end

local function saveData()
    pcall(function() writefile(FILE, HttpSvc:JSONEncode(data)) end)
end

-- Per-id entry:
--   samples / sum / avg / ema  : impact-time stats (only from CONFIRMED hits)
--   min / max / last           : range info
--   deaths                     : kills (3x weight)
--   plays                      : total times this anim started
--   cancels                    : stopped before reaching predicted impact (feints)
--   misses                     : parry fired but damage still landed
--   conf                       : samples + 3*deaths
--   cancelRate                 : cancels/plays (feint frequency)
local EMA_ALPHA = 0.30
-- Streaming OLS regression: impact ≈ a + b * distance, per anim id.
-- Lets us tell apart instant melee (slope≈0) from long-range/dash attacks
-- whose impact time grows with the start distance.
local function record(animId, impactSec, killed, distance)
    if not animId or animId == "" or animId == "?" then return end
    distance = distance or 0
    local e = data[animId]
    if not e then
        e = { samples=0, sum=0, ema=impactSec, last=impactSec,
              min=impactSec, max=impactSec, deaths=0, avg=impactSec,
              plays=0, cancels=0, misses=0,
              -- regression accumulators
              sumD=0, sumI=0, sumDI=0, sumDD=0,
              distAvg=0, distMin=distance, distMax=distance,
              slope=0, intercept=impactSec,
        }
        data[animId] = e
    end
    e.samples = e.samples + 1
    e.sum = e.sum + impactSec
    e.last = impactSec
    e.avg = e.sum / e.samples
    e.ema = EMA_ALPHA * impactSec + (1 - EMA_ALPHA) * (e.ema or impactSec)
    if impactSec < e.min then e.min = impactSec end
    if impactSec > e.max then e.max = impactSec end
    if killed then e.deaths = (e.deaths or 0) + 1 end
    e.conf = e.samples + 3 * (e.deaths or 0)

    -- Distance tracking
    e.sumD  = (e.sumD  or 0) + distance
    e.sumI  = (e.sumI  or 0) + impactSec
    e.sumDI = (e.sumDI or 0) + distance * impactSec
    e.sumDD = (e.sumDD or 0) + distance * distance
    e.distAvg = e.sumD / e.samples
    if distance < (e.distMin or distance) then e.distMin = distance end
    if distance > (e.distMax or distance) then e.distMax = distance end

    -- Fit linear model when we have enough variation.
    if e.samples >= 3 then
        local n   = e.samples
        local denom = n * e.sumDD - e.sumD * e.sumD
        if math.abs(denom) > 1e-3 then
            e.slope = (n * e.sumDI - e.sumD * e.sumI) / denom
            e.intercept = (e.sumI - e.slope * e.sumD) / n
        else
            e.slope = 0; e.intercept = e.avg
        end
    end

    if e.samples % 3 == 0 or killed then saveData() end
end

local function ensure(animId)
    local e = data[animId]
    if not e then
        e = { samples=0, sum=0, avg=0, ema=nil, min=0, max=0,
              last=0, deaths=0, plays=0, cancels=0, misses=0, conf=0 }
        data[animId] = e
    end
    return e
end

-- Called by Combat when an enemy track starts playing.
function AutoParryData.notePlay(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.plays = (e.plays or 0) + 1
end
-- Called when a track stops before reaching the predicted impact (feint).
function AutoParryData.noteCancel(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.cancels = (e.cancels or 0) + 1
    e.cancelRate = e.cancels / math.max(1, e.plays or 1)
end
-- Called when we fired a parry but still took damage shortly after.
-- Only nudge EMA on profiles that already have real samples, otherwise
-- a fresh anim id can have its timing corrupted before it's learned.
-- Combo gap: tracks the typical seconds between consecutive attack animations
-- from the same enemy. Used to predict when the next swing arrives.
-- Combat calls this with the dt between two consecutive attack starts.
function AutoParryData.noteCombo(prevId, nextId, gapSec)
    if not prevId or not nextId or gapSec <= 0 or gapSec > 1.5 then return end
    local e = ensure(prevId)
    e.combo = e.combo or {}
    local c = e.combo[nextId] or { samples = 0, sum = 0, avg = 0 }
    c.samples = c.samples + 1
    c.sum = c.sum + gapSec
    c.avg = c.sum / c.samples
    e.combo[nextId] = c
end

-- Get the expected gap (seconds) from prevId -> nextId. Returns nil if unknown.
function AutoParryData.comboGap(prevId, nextId)
    local e = data[prevId]
    if not e or not e.combo or not e.combo[nextId] then return nil end
    return e.combo[nextId].avg
end

function AutoParryData.noteMiss(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.misses = (e.misses or 0) + 1
    if (e.samples or 0) >= 3 and e.ema then
        e.ema = e.ema + 0.025
    end
    saveData()
end

-- LIVE LEARNER: blends EMA toward observedImpact more aggressively than
-- the passive record() does. Called from Combat when we see the actual
-- impact moment after a parry attempt.
function AutoParryData.learn(animId, observedImpact, killed)
    if not animId or animId == "" or type(observedImpact) ~= "number" then return end
    if observedImpact <= 0.05 or observedImpact > 4.0 then return end
    local e = ensure(animId)
    e.samples = (e.samples or 0) + 1
    e.sum     = (e.sum or 0) + observedImpact
    e.last    = observedImpact
    e.avg     = e.sum / e.samples
    e.min     = math.min(e.min ~= 0 and e.min or observedImpact, observedImpact)
    e.max     = math.max(e.max or 0, observedImpact)
    local alpha = 0.40  -- aggressive: 40% pull toward observation
    e.ema = alpha * observedImpact + (1 - alpha) * (e.ema or e.avg or observedImpact)
    if killed then e.deaths = (e.deaths or 0) + 1 end
    e.conf = (e.samples or 0) + 3 * (e.deaths or 0)
    e.lastLearned = os.clock()
    saveData()
end

-- Parry succeeded (no damage taken in window). Increments confidence stats.
function AutoParryData.noteSuccess(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.successes = (e.successes or 0) + 1
end

-- USER-CALIBRATED TIMING: called when the human player manually presses M2
-- while an enemy attack anim is in progress. The elapsed time from anim
-- start to the press is the GROUND TRUTH parry timing for that anim — far
-- more reliable than guessing from when damage landed.
-- KEYFRAME-DERIVED TIMING (exact, from animation file).
function AutoParryData.fromKeyframes(animId, impactSec)
    if not animId or animId == "" then return end
    if type(impactSec) ~= "number" or impactSec <= 0.02 or impactSec > 4.0 then return end
    local e = ensure(animId)
    e.kfImpact = impactSec
    e.kfTimestamp = os.clock()
    saveData()
end

-- Mark an animation as confirmed-non-attack based on keyframe inspection
-- (no hit-markers, very few keyframes -> idle/movement).
function AutoParryData.markNonAttack(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId)
    e.kfNonAttack = true
    e.plays = math.max(e.plays or 0, 50) -- so isKnownNonAttack returns true
    saveData()
end

function AutoParryData.calibrate(animId, observedSec)
    if not animId or animId == "" then return end
    if type(observedSec) ~= "number" or observedSec <= 0.05 or observedSec > 4.0 then return end
    local e = ensure(animId)
    e.calSamples = (e.calSamples or 0) + 1
    e.calSum     = (e.calSum or 0) + observedSec
    e.calAvg     = e.calSum / e.calSamples
    -- A single calibration sample is worth ~3 passive samples in trust.
    e.calEma = e.calEma and (0.50 * observedSec + 0.50 * e.calEma) or observedSec
    saveData()
end

-- Sanitize corrupted entries from older runs (inf min, broken types).
local function sanitize()
    for id, e in pairs(data) do
        if type(e.min) ~= "number" then e.min = 0 end
        if type(e.max) ~= "number" then e.max = 0 end
        if type(e.ema) ~= "number" then e.ema = nil end
        if type(e.avg) ~= "number" then e.avg = 0 end
    end
end

-- Per-id profile lookup. Threat criteria:
--   * samples >= 2 OR deaths >= 1   (we have evidence)
--   * impact >= 0.15s               (not at animation start)
-- We DON'T gate on samples/plays anymore: many real attacks hit only
-- occasionally, and the ratio filter was rejecting everything.
-- Predict impact time. If currentDist is provided and we have enough samples
-- to fit a regression line, scale impact by distance (long-range moves slow
-- their impact when started far away).
function AutoParryData.lookup(animId, currentDist)
    local e = data[animId]
    if not e then return nil end
    local samples = e.samples or 0
    local deaths  = e.deaths or 0
    -- Require some evidence: keyframes OR calibration OR ≥1 hit OR ≥1 death.
    if not e.kfImpact and (e.calSamples or 0) < 1 and samples < 1 and deaths < 1 then return nil end

    -- Priority order:
    --   1. KeyframeSequenceProvider data (exact, from animation file)
    --   2. User calibration EMA (ground truth from manual parries)
    --   3. Distance regression (if we have ≥3 samples + meaningful slope)
    --   4. Passive EMA from damage attribution
    local impact
    if e.kfImpact then
        impact = e.kfImpact
    elseif e.calEma and (e.calSamples or 0) >= 1 then
        impact = e.calEma
    elseif currentDist and samples >= 3 and e.slope and e.intercept
        and math.abs(e.slope) > 0.003 then
        local predicted = e.intercept + e.slope * currentDist
        local lo, hi = (e.min or 0), (e.max or predicted)
        impact = math.max(lo, math.min(hi, predicted))
    else
        impact = e.ema or e.avg
    end
    if not impact or impact < 0.15 then return nil end

    local offsetMs = (State and State.AutoParryOffset) or -40
    return impact + offsetMs / 1000
end

-- True if id is a known attack we'll trust enough to parry.
function AutoParryData.isAttack(animId)
    local e = data[animId]
    if not e then return false end
    return (e.samples or 0) >= 2 or (e.deaths or 0) >= 1
end

-- True for ids that played a lot and never dealt damage (idle, run, wind-down).
function AutoParryData.isKnownNonAttack(animId)
    local e = data[animId]
    if not e then return false end
    if e.kfNonAttack then return true end
    return (e.samples or 0) == 0 and (e.deaths or 0) == 0 and (e.plays or 0) >= 20
end

function AutoParryData.all() return data end

function AutoParryData.export()
    local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if cb then pcall(cb, HttpSvc:JSONEncode(data)) end
    saveData()
end

function AutoParryData.reset()
    data = {}; saveData()
end

local function withinRange(char)
    if not char then return false end
    local r = char:FindFirstChild("HumanoidRootPart")
    local _, me = getCharParts()
    if not (r and me) then return false end
    return (r.Position - me.Position).Magnitude <= 30
end

local hookedHums = setmetatable({}, { __mode = "k" })
local function hookEnemy(hum)
    if not hum or hookedHums[hum] then return end
    hookedHums[hum] = true
    active[hum] = {}
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        if not withinRange(hum.Parent) then return end
        local id = (track.Animation and track.Animation.AnimationId or ""):gsub("rbxassetid://", "")
        if id == "" then return end
        -- Distance at start (used by the regression).
        local dist = 0
        local r  = hum.Parent and hum.Parent:FindFirstChild("HumanoidRootPart")
        local _, me = getCharParts()
        if r and me then dist = (r.Position - me.Position).Magnitude end
        active[hum][id] = { start = os.clock(), dist = dist }
        local stopConn
        stopConn = track.Stopped:Connect(function()
            if active[hum] then active[hum][id] = nil end
            if stopConn then stopConn:Disconnect() end
        end)
        Conns.add(stopConn)
    end))
end

-- Use the shared Humanoids registry instead of a second workspace scan +
-- DescendantAdded listener (those duplicated work the registry already does).
Humanoids.onAdded(function(hum)
    if hum.Parent ~= LP.Character then hookEnemy(hum) end
end)

-- Credit the most-recent active enemy track within range.
local function creditAttack(killed)
    local now = os.clock()
    local bestId, bestStart, bestDist = nil, -math.huge, 0
    for hm, ids in pairs(active) do
        if hm and hm.Parent and withinRange(hm.Parent) then
            for id, info in pairs(ids) do
                local startT = info.start or info  -- back-compat
                if startT > bestStart then
                    bestStart = startT; bestId = id
                    bestDist = info.dist or 0
                end
            end
        end
    end
    if bestId then
        local impact = now - bestStart
        if impact > 0.05 and impact < 3.0 then
            record(bestId, impact, killed, bestDist)
        end
    end
end

-- Damage detection + death analysis on the LocalPlayer's humanoid.
local function bindLocalHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local lastHealth = hum.Health
    Conns.add(hum.HealthChanged:Connect(function(h)
        if h < lastHealth then creditAttack(false) end
        lastHealth = h
    end))
    -- Killing blow: stronger evidence; recorded with deaths++ and persisted.
    Conns.add(hum.Died:Connect(function() creditAttack(true) end))
end

if LP.Character then bindLocalHumanoid(LP.Character) end
Conns.add(LP.CharacterAdded:Connect(bindLocalHumanoid))

loadData()
sanitize()

function AutoParryData.init(state) State = state end
return AutoParryData

end)
__bundle_register("Utility/Logger", function(require, _LOADED, __bundle_register, __bundle_modules)
local Logger = {}
local function emit(level, ...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    print("[" .. level .. "] " .. table.concat(parts, " "))
end
function Logger.info(...) emit("info", ...) end
function Logger.warn(...) warn(...) end
function Logger.error(...) emit("error", ...) end
return Logger

end)
__bundle_register("Utility/State", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Shared state. Each feature reads/writes here. Saved per-session only.
return {
    -- Movement
    Fly=false, FlySpeed=100,
    Noclip=false,
    ToggleSprint=false,
    -- Tween To Back (attach behind nearest enemy)
    TweenToBack=false, TTBSticky=false, TTBIgnorePlayers=true,
    TTBDistance=5, TTBHeight=0, TTBSpeed=200, TTBRange=300,

    -- Visuals
    Fullbright=false,
    LowGfx=false,
    -- Individual visual removals (deepwoken-rewrite set). LowGfx flips all four.
    NoFog=false, NoBlur=false, NoShadows=false, NoAnimatedSea=false,
    ESP=false, ESPRange=1500, ESPHealth=true, ESPDistance=true, ESPName=true,
    ESPOutline=true, ESPWeapon=true, ESPSplitHealth=false,
    ESPPlayers=true, ESPNPCs=true, ESPMobs=true, ESPTextScale=100, ESPNameScale=100,
    ESPHitbox=false,                            -- draw the parry hitbox box
    ESPLimitUpdates=true, ESPRefreshRate=30,    -- throttle ESP redraws (updates/sec)
    ESPMaxTargets=0,                            -- cap rendered ESP objects to nearest N (0 = unlimited)
    ESPBox=false, ESPBoxBar=true,               -- 2D screen-space box + side health bar
    ESPSplitUpdates=false, ESPSplitFrames=3,    -- spread tag updates across N ticks
    NoPersistentESP=false,                      -- let ESP character models stream out
    StreamProof=true,                           -- hide the menu/GUIs from screen capture
    YouTuberChecker=false,                       -- toast when a known YouTuber joins
    -- ESP combat stats (Type Soul: read from each character's Status folder)
    ESPReiatsu=false, ESPPosture=false, ESPStamina=false, ESPRaceForm=false, ESPStates=false,
    AnimViz=false, AnimAllChars=true, AnimVizRange=0,   -- 0 = unlimited

    -- Combat / AutoParry  (tuned defaults: reliable parrying out of the box)
    -- DetectionRange is the SINGLE distance AutoParry uses for everything:
    -- proximity gate + attack-hitbox width/height/reach. The legacy keys below
    -- are kept in lockstep with it (Combat.setDetectionRange / Combat.init) so
    -- they can never drift. Lower it to stop parrying far-away attacks.
    AutoParry=false, DetectionRange=18, AutoParryKey="MouseButton2",
    AutoParryRange=18,                          -- derived from DetectionRange
    AutoDodge=true,                             -- dash (Requests.Dash) on saved dodge timings
    TimingOffset=0,                             -- manual fine-tune (seconds, +later/−earlier)
    BlockHold=0.35,                             -- how long to hold block so it's active at impact (s)
    ParryNearestOnly=false, ParryPlayersOnly=false, ParryMobsOnly=false,
    ParryFacingMe=false, FacingDot=0.35,        -- only parry attackers facing you (~70° cone)
    FacingPredict=true, HitboxHistory=true,     -- deepwoken-style: predict turn-ins + test recent positions
    ParryWhenUnfocused=false,
    HitboxPredict=false, HitboxSize=18,         -- derived from DetectionRange (width/height, studs)
    HitboxReach=18,                             -- derived from DetectionRange (forward depth, studs)
    -- Hitbox Range — projectile/hitbox PROXIMITY detection, separate from the
    -- animation-timing parry and from Detection Range above. Reacts to the actual
    -- projectile position for ranged attacks instead of the (early) animation.
    HitboxRangeMode=false,                       -- master toggle for the mode
    HitboxRangeParry=true, HitboxRangeDodge=false,  -- which reaction fires on entry
    HitboxParryRange=25, HitboxParryDelay=0,     -- studs ; seconds after entry
    HitboxDodgeRange=25, HitboxDodgeDelay=0,     -- studs ; seconds after entry
    HitboxMinDist=0,                             -- only watch projectiles that APPEAR ≥ this far (filters local melee effects); 0 = off (default, so projectile parry always works)
    HitboxAutoDetect=true,                       -- name-agnostic: react to ANY part that travels + approaches you (no capture list needed)
    ProjDebug=false,                             -- live log: saved-projectile detected / parry fired / no-react / failed
    HitboxMaxDist=0,                             -- max engage distance: ignore projectiles whose CENTER is farther than this (0 = unlimited)
    HitboxAutoMinAxis=1.2,                       -- auto-detect ignores parts whose biggest dimension is under this (skips tiny spark/blood particles)
    HitboxAutoMaxAxis=130,                        -- auto-detect ignores parts BIGGER than this (skips map geometry; ceros can be ~100 studs so keep this high)
    RepeatOnMiss=true, RepeatOnMissMax=2,       -- re-attempt parry if one whiffs
    HighPing=false,                             -- press earlier + hold longer for jittery 150ms+ ping
    Feint=false, FeintWindow=0.25,              -- feint your swing if mid-attack when parrying
    SmartHit=false, SmartHitWindow=0.25,        -- "Auto Feint": feint own swing when a parry is imminent
    AutoFeintType="Passive", DelayedFeints=false, -- Auto Feint mode (Passive/Aggressive) + hold to latest moment
    MeasureOnHit=false,                          -- learn a move's impact timing automatically the moment it damages you (fills gaps in your sheet)
    PlayerTiming=false, PlayerTimingRange=22,   -- learn parry timings; PlayerTimingProjDist = projectile capture distance
    PlayerTimingProjDist=40,                      -- only capture projectiles that come within this far
    -- deepwoken extras
    FailSim=false, FailRate=10,                 -- intentionally miss FailRate% of parries (look human)
    RPUE=false, RPUEInterval=200,               -- repeat-until-end: re-block every N ms while the attack plays
    APBreaker=false, APBreakerSpeed=6,          -- ignore spoofed animations (abnormal speed / near-zero weight)

    -- Spyware / Remote Spy
    Spyware=false, SpyPaused=false, SpySelf=true, SpyEnemies=false,

    -- Mod checker / debug / notifications
    ModeratorChecker=true, Debug=false,
    NotificationsEnabled=true,
    NotifToggles=true, NotifSafety=true,        -- per-category notification filters
    KeybindHud=true,
}

end)
return __bundle_require("__root")