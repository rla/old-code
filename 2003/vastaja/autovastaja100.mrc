menu Channel,menubar {
  &Autovastaja
  .On:{
    .enable #autovastajaviiv 
    set %autovastaja 1 
  echo -a ***Trivia autovastaja on nüüd sisse lülitatud }
  .Off:{
    .disable #autovastajaviiv
    set %autovastaja 0 
  echo -a ***Trivia autovastaja on nüüd välja lülitatud }
  .Viivituse aeg
  ..O sec:/.set %ttvtime 1 | echo -a 3 ***Trivia autovastaja aeg on nüüd 0 sekundit
  ..1 sec:/.set %ttvtime 2 | echo -a 3 ***Trivia autovastaja aeg on nüüd 1 sekund
  ..2 sec:/.set %ttvtime 3 | echo -a 3 ***Trivia autovastaja aeg on nüüd 2 sekundit
  ..3 sec:/.set %ttvtime 4 | echo -a 3 ***Trivia autovastaja aeg on nüüd 3 sekundit
  ..4 sec:/.set %ttvtime 5 | echo -a 3 ***Trivia autovastaja aeg on nüüd 4 sekundit
  ..5 sec:/.set %ttvtime 6 | echo -a 3 ***Trivia autovastaja aeg on nüüd 5 sekundit

}


#autovastajaviiv on


on 1:TEXT:*irbis*:#:/. timer 1 %ttvtime msg # lumeleopard
on 1:TEXT:*mitu tähte*usa*:#:/. timer 1 %ttvtime msg # 50
on 1:TEXT:*võtame*mõnuga*:#:/. timer 1 %ttvtime msg # saaremaa viin
on 1:TEXT:*jugoslaavia*pealinn*:#:/. timer 1 %ttvtime msg # belgrad
on 1:TEXT:*mida*uurib*veksilloloogia*:#:/. timer 1 %ttvtime msg # lippe
on 1:TEXT:*fields*love*:#:/. timer 1 %ttvtime msg # atb vs york
on 1:TEXT:*ei*tunne*lõhna*:#:/. timer 1 %ttvtime msg # kinganina
on 1:TEXT:*eukalüptipuu*:#:/. timer 1 %ttvtime msg # koaala
on 1:TEXT:*manhattan*:#:/. timer 1 %ttvtime msg # kosmeetikat
on 1:TEXT:*värv*piljardis*:#:/. timer 1 %ttvtime msg # kollane
on 1:TEXT:*kaali*meteoriidikraater*:#:/. timer 1 %ttvtime msg # saaremaa
on 1:TEXT:*contradanza*:#:/. timer 1 %ttvtime msg # vanessa mae
on 1:TEXT:*another*change*:#:/. timer 1 %ttvtime msg # roger sanchez
on 1:TEXT:*kalevipoja*:#:/. timer 1 %ttvtime msg # teder
on 1:TEXT:*flower*:#:/. timer 1 %ttvtime msg # moby
on 1:TEXT:*under*pressure*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*käppa*:#:/. timer 1 %ttvtime msg # neli
on 1:TEXT:*rle*:#:/. timer 1 %ttvtime msg # radiolinja eesti
on 1:TEXT:*killer*2000*:#: timer 1 %ttvtime /.msg # atb
on 1:TEXT:*jupiteril*:#:/. timer 1 %ttvtime msg # 16
on 1:TEXT:*võidupüha*:#:/. timer 1 %ttvtime msg # 23.juuni
on 1:TEXT:*your*life*:#:/. timer 1 %ttvtime msg # smokie
on 1:TEXT:*küünlapäev*:#:/. timer 1 %ttvtime msg # 2.veebruar
on 1:TEXT:*paks*:#:/. timer 1 %ttvtime msg # peenike
on 1:TEXT:*eesti*slovaki*:#:/. timer 1 %ttvtime msg # estonsko
on 1:TEXT:*eesti*prantsuse*:#:/. timer 1 %ttvtime msg # estonie
on 1:TEXT:*saksamaa*pealinn*:#:/. timer 1 %ttvtime msg # berliin
on 1:TEXT:*25 ruudus*:#:/. timer 1 %ttvtime msg # 625
on 1:TEXT:*kõrgeim*õhutemperatuur*:#:/. timer 1 %ttvtime msg # +35,2 kraadi
on 1:TEXT:*valge*valgus*:#:/. timer 1 %ttvtime msg # liitvalgus
on 1:TEXT:*peaosa*mask*:#:/. timer 1 %ttvtime msg # jim carrey
on 1:TEXT:*suurim*ookean*:#:/. timer 1 %ttvtime msg # vaikne ookean
on 1:TEXT:*inoucdjouac*:#:/. timer 1 %ttvtime msg # linn
on 1:TEXT:*lääne*virumaa*keskus*:#:/. timer 1 %ttvtime msg # rakvere
on 1:TEXT:*lähme*sõidame*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*korrust*kaubamajal*:#:/. timer 1 %ttvtime msg # 5
on 1:TEXT:*mim*:#:/. timer 1 %ttvtime msg # 1999
on 1:TEXT:*ahviliik*:#:/. timer 1 %ttvtime msg # laar
on 1:TEXT:*glen*rice*:#:/. timer 1 %ttvtime msg # korvpallur
on 1:TEXT:*pedja*jõgi*:#:/. timer 1 %ttvtime msg # 122 km
on 1:TEXT:*punaste*laternate*tänav*:#:/. timer 1 %ttvtime msg # tatari
on 1:TEXT:*the night*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*tvkanal*ti*ger*:#:/. timer 1 %ttvtime msg # etv
on 1:TEXT:*korraks vaid*:#:/. timer 1 %ttvtime msg # horoskoop
on 1:TEXT:*we will rock you*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*mõrvas kennedy*:#:/. timer 1 %ttvtime msg # lee harvey oswald
on 1:TEXT:*müristab*välku*:#:/. timer 1 %ttvtime msg # vanapagan silku sööb
on 1:TEXT:*give it up*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*1.maailmasõda*:#:/. timer 1 %ttvtime msg # 1914
on 1:TEXT:*mis on jõgevamaa keskus*:#:/. timer 1 %ttvtime msg # jõgeva
on 1:TEXT:*alati sinuga*:#:/. timer 1 %ttvtime msg # emt
on 1:TEXT:*lima*:#:/. timer 1 %ttvtime msg # peruu
on 1:TEXT:*eestist lõunas*:#:/. timer 1 %ttvtime msg # läti
on 1:TEXT:*aasta*vibe*:#:/. timer 1 %ttvtime msg # 3
on 1:TEXT:*win the race*:#:/. timer 1 %ttvtime msg # modern talking
on 1:TEXT:*väike*armastab*piima*:#:/. timer 1 %ttvtime msg # siil
on 1:TEXT:*tadz*mahal*:#:/. timer 1 %ttvtime msg # agra
on 1:TEXT:*kuristik rukkis*:#:/. timer 1 %ttvtime msg # salinger
on 1:TEXT:*kasvab*kahaneb*otsa*:#:/. timer 1 %ttvtime msg # kuu
on 1:TEXT:*caater 2000*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*usa*surmanuhtlus*:#:/. timer 1 %ttvtime msg # 38
on 1:TEXT:*dingo kodumaa*:#:/. timer 1 %ttvtime msg # austraalia
on 1:TEXT:*fat*girls*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*kalu*vees*:#:/. timer 1 %ttvtime msg # värskeid
on 1:TEXT:*20.aprill*:#:/. timer 1 %ttvtime msg # reede
on 1:TEXT:*riik*vanim*ülikool*:#:/. timer 1 %ttvtime msg # itaalia
on 1:TEXT:*hinne*neli*:#:/. timer 1 %ttvtime msg # hea
on 1:TEXT:*külge*ruudul*:#:/. timer 1 %ttvtime msg # neli
on 1:TEXT:*valgevene*pealinn*:#:/. timer 1 %ttvtime msg # minsk
on 1:TEXT:*private dancer*:#:/. timer 1 %ttvtime msg # tina turner
on 1:TEXT:*nba meistrid*:#:/. timer 1 %ttvtime msg # los angelas lakers
on 1:TEXT:*hispaania rahatäheks*:#:/. timer 1 %ttvtime msg # peseeta
on 1:TEXT:*huri-khan*:#:/. timer 1 %ttvtime msg # storm
on 1:TEXT:*eesti*läbirääkimisi astumaks euroopa*:#:/. timer 1 %ttvtime msg # 1998
on 1:TEXT:*whats my age again*:#:/. timer 1 %ttvtime msg # blink 182
on 1:TEXT:*mitu linna eestis*:#:/. timer 1 %ttvtime msg # 47
on 1:TEXT:*lugu*lovemachine*:#:/. timer 1 %ttvtime msg # aquagen
on 1:TEXT:*usa*air force one*:#:/. timer 1 %ttvtime msg # harrison ford
on 1:TEXT:*killer queen*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*bänd on caater*:#:/. timer 1 %ttvtime msg # eesti
on 1:TEXT:*tantsin sinuga taevas*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*lugu on stuck*:#:/. timer 1 %ttvtime msg # limp bizkit
on 1:TEXT:*eesti kuulatuim raadiojaam*:#:/. timer 1 %ttvtime msg # vikerraadio
on 1:TEXT:*i*m*back*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*mitu tähte*austraalia*:#:/. timer 1 %ttvtime msg # 6
on 1:TEXT:*armastavad*vampiirid*:#:/. timer 1 %ttvtime msg # verd
on 1:TEXT:*a kind of magic*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*eestist loodes*:#:/. timer 1 %ttvtime msg # rootsi
on 1:TEXT:*valdkonnas*fieldsi preemiaid*:#:/. timer 1 %ttvtime msg # matemaatika
on 1:TEXT:*grammi*inimese*peaaju*:#:/. timer 1 %ttvtime msg # 1400
on 1:TEXT:*eesti*esimene*laulupidu*:#:/. timer 1 %ttvtime msg # 1869
on 1:TEXT:*läti pealinn*:#:/. timer 1 %ttvtime msg # riia
on 1:TEXT:*miks*jumal*blondiinid*:#:/. timer 1 %ttvtime msg # sest brünetid ei saanud asjaga hakkama
on 1:TEXT:*eestist läänes*:#:/. timer 1 %ttvtime msg # rootsi
on 1:TEXT:*miks ööd on pimedad*:#:/. timer 1 %ttvtime msg # sest siis ei paista päike
on 1:TEXT:*lugu*rikutud süda*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*peaosa*beverly hills cop*:#:/. timer 1 %ttvtime msg # eddie murphy
on 1:TEXT:*millal*jaanipäev*:#:/. timer 1 %ttvtime msg # 24.juuni
on 1:TEXT:*el*idioma*:#:/. timer 1 %ttvtime msg # keel
on 1:TEXT:*mitmes*30 päeva*:#:/. timer 1 %ttvtime msg # 11
on 1:TEXT:*lugu*angels*crying*:#:/. timer 1 %ttvtime msg # e-type
on 1:TEXT:*millises*sõtke*veehoidla*:#:/. timer 1 %ttvtime msg # sillamäe
on 1:TEXT:*laul*claudette*:#:/. timer 1 %ttvtime msg # roy orbison
on 1:TEXT:*laul*ameno*:#:/. timer 1 %ttvtime msg # era
on 1:TEXT:*laul*tuttu frutti*86*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*filmis*lugu*now we are free*:#:/. timer 1 %ttvtime msg # gladiator
on 1:TEXT:*uusim windows*:#:/. timer 1 %ttvtime msg # windows xp
on 1:TEXT:*lugu*movin melodies*:#:/. timer 1 %ttvtime msg # atb
on 1:TEXT:*laul*mustapha*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*kes*dennis bergkamp*:#:/. timer 1 %ttvtime msg # jalgpallur
on 1:TEXT:*kes*johnny depp*:#:/. timer 1 %ttvtime msg # näitleja
on 1:TEXT:*millisele*ei saa*jaatavalt*:#:/. timer 1 %ttvtime msg # kas sa magad?
on 1:TEXT:*mida*anno*domini*:#:/. timer 1 %ttvtime msg # issanda aastal
on 1:TEXT:*lugu*jalga niisket maad*:#:/. timer 1 %ttvtime msg # terminaator
on 1:TEXT:*lugu*kill you*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*loomad*kardavad*vett*:#:/. timer 1 %ttvtime msg # kassid
on 1:TEXT:*lugu*blue*:#:/. timer 1 %ttvtime msg # eiffel 65
on 1:TEXT:*lugu*lendaval vaibal*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*laul*can somebody tell me who i am*:#:/. timer 1 %ttvtime msg # orange blue
on 1:TEXT:*1 toll on mitu cm*:#:/. timer 1 %ttvtime msg # 2,54
on 1:TEXT:*mitu päeva*oktoobris*:#:/. timer 1 %ttvtime msg # 31
on 1:TEXT:*lipul*ülemine*erepunane*alumine*valge*:#:/. timer 1 %ttvtime msg # indoneesia
on 1:TEXT:*lugu*sinine vagun*:#:/. timer 1 %ttvtime msg # vennaskond
on 1:TEXT:*valge maapinna kate*:#:/. timer 1 %ttvtime msg # lumi
on 1:TEXT:*teostamatu unistus ehk*:#:/. timer 1 %ttvtime msg # utoopia
on 1:TEXT:*lugu*lemon tree*:#:/. timer 1 %ttvtime msg # fools garden
on 1:TEXT:*linnas*loveparade*:#:/. timer 1 %ttvtime msg # berliin
on 1:TEXT:*laul*devore amante*:#:/. timer 1 %ttvtime msg # era
on 1:TEXT:*lugu*freak*:#:/. timer 1 %ttvtime msg # 666
on 1:TEXT:*kui pikk*võhandi jõgi*:#:/. timer 1 %ttvtime msg # 162 km
on 1:TEXT:*mida*prantslased*lord*winston*:#:/. timer 1 %ttvtime msg # viski
on 1:TEXT:*lugu*porcelain*:#:/. timer 1 %ttvtime msg # moby
on 1:TEXT:*mis*küsimusele*analoogiline*:#:/. timer 1 %ttvtime msg # millega?
on 1:TEXT:*mis on*eesti suvepealinn*:#:/. timer 1 %ttvtime msg # pärnu
on 1:TEXT:*kes*eesti presidendiks aastal 2001*:#:/. timer 1 %ttvtime msg # arnolt rüütel
on 1:TEXT:*lugu*clown*:#:/. timer 1 %ttvtime msg # korn
on 1:TEXT:*uus Wolksvageni passat*:#:/. timer 1 %ttvtime msg # üle oma klassi
on 1:TEXT:*eesti*madalaim*õhutemperatuur*:#:/. timer 1 %ttvtime msg # -43,5 kraadi
on 1:TEXT:*läbipaistev materjal*:#:/. timer 1 %ttvtime msg # klaas
on 1:TEXT:*lugu*the ballad of chasey lane*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*palju*6 korda 6*:#:/. timer 1 %ttvtime msg # 36
on 1:TEXT:*linn*kus*saku õlletehas*:#:/. timer 1 %ttvtime msg # saku
on 1:TEXT:*millal*tartu ülikool*:#:/. timer 1 %ttvtime msg # 1632
on 1:TEXT:*mis toode*bronnley*:#:/. timer 1 %ttvtime msg # kreem
on 1:TEXT:*toode*cocio*:#:/. timer 1 %ttvtime msg # joodav
on 1:TEXT:*mitu*grammi on 1 karaat*:#:/. timer 1 %ttvtime msg # 0,2
on 1:TEXT:*kui vanalt*kanget alkoholi*:#:/. timer 1 %ttvtime msg # 21
on 1:TEXT:*lugu*adidas*:#:/. timer 1 %ttvtime msg # korn
on 1:TEXT:*kui palju*9 korda 9*:#:/. timer 1 %ttvtime msg # 81
on 1:TEXT:*laul*innuendo*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*suur ja*:#:/. timer 1 %ttvtime msg # väike
on 1:TEXT:*kui suur*alma*rasva sisaldus*:#:/. timer 1 %ttvtime msg # 2,5%
on 1:TEXT:*lugu*dance with you*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*kes*teeb silla*ilma kirveta*:#:/. timer 1 %ttvtime msg # pakane
on 1:TEXT:*laul*crawling*:#:/. timer 1 %ttvtime msg # linkin park
on 1:TEXT:*laul*pacman*:#:/. timer 1 %ttvtime msg # dj maui
on 1:TEXT:*lugu*technorocker*:#:/. timer 1 %ttvtime msg # dj balloon
on 1:TEXT:*eesti*suurim*saar*:#:/. timer 1 %ttvtime msg # saaremaa
on 1:TEXT:*hambad ei söö toitu*:#:/. timer 1 %ttvtime msg # saehambad
on 1:TEXT:*kelle*teos*kevade*:#:/. timer 1 %ttvtime msg # oskar luts
on 1:TEXT:*riigis*kanep*seaduslik*:#:/. timer 1 %ttvtime msg # hollandis
on 1:TEXT:*puu*aucuparia*keeles*:#:/. timer 1 %ttvtime msg # pihlakas
on 1:TEXT:*lugu*yummie down on this*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*mitu*valda*eestis*:#:/. timer 1 %ttvtime msg # 207
on 1:TEXT:*mis*2000*kõige turvalisem linn*:#:/. timer 1 %ttvtime msg # kärdla
on 1:TEXT:*mis maa lipp on üleni roheline*:#:/. timer 1 %ttvtime msg # liibüa
on 1:TEXT:*mis auto*eesti ekspressiga võita*:#:/. timer 1 %ttvtime msg # jaguar s-type
on 1:TEXT:*kelle lugu on three litle pigs*:#:/. timer 1 %ttvtime msg # green jelly
on 1:TEXT:*itaalia*pealinn*:#:/. timer 1 %ttvtime msg # rooma
on 1:TEXT:*mida*butüromeetriga*:#:/. timer 1 %ttvtime msg # piima rasvasisaldust
on 1:TEXT:*laul*superstar*:#:/. timer 1 %ttvtime msg # rollergirl
on 1:TEXT:*lugu*nüüd on nii hea*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*kus asub kärdla*:#:/. timer 1 %ttvtime msg # hiiumaal
on 1:TEXT:*mis*järvamaa keskus*:#:/. timer 1 %ttvtime msg # paide
on 1:TEXT:*mitu päeva*detsembris*:#:/. timer 1 %ttvtime msg # 31
on 1:TEXT:*lugu*kayama*:#:/. timer 1 %ttvtime msg # atb
on 1:TEXT:*lühim kohanimi eestis*:#:/. timer 1 %ttvtime msg # aa
on 1:TEXT:*laul*where are you*:#:/. timer 1 %ttvtime msg # paffendorf
on 1:TEXT:*mis*eesti pealinn*:#:/. timer 1 %ttvtime msg # tallinn
on 1:TEXT:*laul*she*got that light*:#:/. timer 1 %ttvtime msg # orange blue
on 1:TEXT:*filmi*rüütli lugu*lavastaja*:#:/. timer 1 %ttvtime msg # brian helgeland
on 1:TEXT:*kes*toxic*omasõnul*:#:/. timer 1 %ttvtime msg # meesnaine
on 1:TEXT:*kes*silla*kirve*naelata*:#:/. timer 1 %ttvtime msg # pakane
on 1:TEXT:*mitu päeva*nädalas*:#:/. timer 1 %ttvtime msg # 7
on 1:TEXT:*mis*punane*liigub üles alla*:#:/. timer 1 %ttvtime msg # tomat liftis
on 1:TEXT:*laul*because*got high*:#:/. timer 1 %ttvtime msg # afroman
on 1:TEXT:*lugu*princess og egypt*:#:/. timer 1 %ttvtime msg # e-type
on 1:TEXT:*millal*pärtlipäev*:#:/. timer 1 %ttvtime msg # 24.august
on 1:TEXT:*mis*küsimusele*tuginema*:#:/. timer 1 %ttvtime msg # millele?
on 1:TEXT:*milline*metall*põeb katku*:#:/. timer 1 %ttvtime msg # tina
on 1:TEXT:*maa*auto*ferrari*:#:/. timer 1 %ttvtime msg # itaalia
on 1:TEXT:*tähtkuju 21.dets*:#:/. timer 1 %ttvtime msg # kaljukits
on 1:TEXT:*filmis*mission impossible 2*:#:/. timer 1 %ttvtime msg # tom cruise
on 1:TEXT:*riik*usa*lõunas*:#:/. timer 1 %ttvtime msg # mehiko
on 1:TEXT:*kes*rivaldo*:#:/. timer 1 %ttvtime msg # jalgpallur
on 1:TEXT:*lugu*a kind of magic*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*riik*läti*lõunas*:#:/. timer 1 %ttvtime msg # leedu
on 1:TEXT:*mitu tähte*meremaa*lipul*:#:/. timer 1 %ttvtime msg # 4
on 1:TEXT:*mitu*tähte*ameerika*lipul*:#:/. timer 1 %ttvtime msg # 50
on 1:TEXT:*mis*maa*auto*suzuki*:#:/. timer 1 %ttvtime msg # jaapan
on 1:TEXT:*mis*venemaa*pealinn*:#:/. timer 1 %ttvtime msg # moskva
on 1:TEXT:*laul*snowflakes*:#:/. timer 1 %ttvtime msg # princessa
on 1:TEXT:*millal*leinapäev*:#:/. timer 1 %ttvtime msg # 14.juuni
on 1:TEXT:*mitu*lehekülge*ene*kaartides*:#:/. timer 1 %ttvtime msg # 224
on 1:TEXT:*mitu*gram*5*kroon*:#:/. timer 1 %ttvtime msg # 7,1
on 1:TEXT:*lugu*ain*it*funny*:#:/. timer 1 %ttvtime msg # jennifer lopez
on 1:TEXT:*lugu*the bad touch*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*kes*ei*kuulu*napsteri*hulka*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*mereröövel ehk*:#:/. timer 1 %ttvtime msg # piraat
on 1:TEXT:*mis*spordialaga*valerie*nikitin*:#:/. timer 1 %ttvtime msg # kreeka-rooma maadlusega
on 1:TEXT:*lugu*the night*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*maailma kõige väiksem asi*:#:/. timer 1 %ttvtime msg # kükitav mannatera
on 1:TEXT:*lugu*the fields of love*:#:/. timer 1 %ttvtime msg # atb
on 1:TEXT:*lugu*no speech*:#:/. timer 1 %ttvtime msg # guano apes
on 1:TEXT:*lugu*mope*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*riik*rootsist*läänes*:#:/. timer 1 %ttvtime msg # norra
on 1:TEXT:*kes on raul*:#:/. timer 1 %ttvtime msg # jalgpallur
on 1:TEXT:*mis*iirimaa*pealinn*:#:/. timer 1 %ttvtime msg # dublin
on 1:TEXT:*millises*shows*bulbsaor*pikachu*:#:/. timer 1 %ttvtime msg # pokemon
on 1:TEXT:*okkaline taim*kasvab kuivas*:#:/. timer 1 %ttvtime msg # kaktus
on 1:TEXT:*riik*eesti*põhjas*:#:/. timer 1 %ttvtime msg # soome
on 1:TEXT:*riik*canada*lõunas*:#:/. timer 1 %ttvtime msg # usa
on 1:TEXT:*laul*i*m*back*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*linn*b*a*d*cimema*:#:/. timer 1 %ttvtime msg # paide
on 1:TEXT:*prantsusmaa*pealinn*:#:/. timer 1 %ttvtime msg # pariis
on 1:TEXT:*mida*demo*esma*5.juulil 1946*:#:/. timer 1 %ttvtime msg # bikiine
on 1:TEXT:*kes*vince*carter*:#:/. timer 1 %ttvtime msg # korvpallur
on 1:TEXT:*hispaania*bueno*:#:/. timer 1 %ttvtime msg # hea
on 1:TEXT:*leedu*pealinn*:#:/. timer 1 %ttvtime msg # vilnius
on 1:TEXT:*hädabi number*:#:/. timer 1 %ttvtime msg # 112
on 1:TEXT:*hispaania*pealinn*:#:/. timer 1 %ttvtime msg # madriid
on 1:TEXT:*lugu*around the world*:#:/. timer 1 %ttvtime msg # atc
on 1:TEXT:*lugu*nüüd on nii hea*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*nobeli*preemia*asutaja*:#:/. timer 1 %ttvtime msg # alfred
on 1:TEXT:*riik*eesti*ida*:#:/. timer 1 %ttvtime msg # venemaa
on 1:TEXT:*emt*pikalt*:#:/. timer 1 %ttvtime msg # eesti mobiiltelefon
on 1:TEXT:*mitu*moodustavad*sood*:#:/. timer 1 %ttvtime msg # 22%
on 1:TEXT:*tähtkuju*21.märts*:#:/. timer 1 %ttvtime msg # jäär
on 1:TEXT:*peaosa*filmis*the truman show*:#:/. timer 1 %ttvtime msg # jim carrey
on 1:TEXT:*kelle*lugu*don*t*go off wondering*:#:/. timer 1 %ttvtime msg # limp bizkit
on 1:TEXT:*mida*carpe diem*:#:/. timer 1 %ttvtime msg # kasuta hetke
on 1:TEXT:*millal*jüripäev*:#:/. timer 1 %ttvtime msg # 23.aprill
on 1:TEXT:*proovi*keelega*:#:/. timer 1 %ttvtime msg # kiss
on 1:TEXT:*peaosa*coyote ugly*:#:/. timer 1 %ttvtime msg # piper perabo
on 1:TEXT:*lugu*suck my dick*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*kelle*vainulilled*:#:/. timer 1 %ttvtime msg # koidula
on 1:TEXT:*mis aastal*2*maailma*sõda*:#:/. timer 1 %ttvtime msg # 1939
on 1:TEXT:*mis maa*jalgpallur*:#:/. timer 1 %ttvtime msg # portugali
on 1:TEXT:*lugu*sinu küljes kinni*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*lugu*jää*:#:/. timer 1 %ttvtime msg # terminaator
on 1:TEXT:*lugu*jealously*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*eesti*islandi keeles*:#:/. timer 1 %ttvtime msg # eistland
on 1:TEXT:*mis*hiiumaa*keskus*:#:/. timer 1 %ttvtime msg # kärdla
on 1:TEXT:*üks ööpäev on*:#:/. timer 1 %ttvtime msg # 24 tundi
on 1:TEXT:*kes*eesti*rahandus minister*:#:/. timer 1 %ttvtime msg # siim kallas
on 1:TEXT:*laul*bicycle race*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*laul*the whistle song*:#:/. timer 1 %ttvtime msg # dj aligator
on 1:TEXT:*mis*tegeleb*valeri nikitin*:#:/. timer 1 %ttvtime msg # kreeka-rooma maadlusega
on 1:TEXT:*lugu*hold that sucker down*:#:/. timer 1 %ttvtime msg # caater
on 1:TEXT:*laul*butterfly*:#:/. timer 1 %ttvtime msg # crazy town
on 1:TEXT:*laul*diablo*:#:/. timer 1 %ttvtime msg # 666
on 1:TEXT:*laul*typical male*:#:/. timer 1 %ttvtime msg # tina turner
on 1:TEXT:*milline*asi*dewari anum*:#:/. timer 1 %ttvtime msg # termos
on 1:TEXT:*laul*pacman*:#:/. timer 1 %ttvtime msg # dj maui
on 1:TEXT:*alma*piima*rasvasisaldus*:#:/. timer 1 %ttvtime msg # 2,5%
on 1:TEXT:*lugu*magna cum nada*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*lugu*stan*:#:/. timer 1 %ttvtime msg # eminem
on 1:TEXT:*laul*ebuda*:#:/. timer 1 %ttvtime msg # enia
on 1:TEXT:*venemaa*president*:#:/. timer 1 %ttvtime msg # vladimir putin
on 1:TXET:*kes*eesti*hõivatum inimene*:#:/. timer 1 %ttvtime msg # toomas luman
on 1:TEXT:*hispaania*raha*:#:/. timer 1 %ttvtime msg # peseeta
on 1:TEXT:*mitu*vikerkaarel*:#:/. timer 1 %ttvtime msg # 7
on 1:TEXT:*laul*where did you sleep last night*:#:/. timer 1 %ttvtime msg # nirvana
on 1:TEXT:*lugu*sad but true*:#:/. timer 1 %ttvtime msg # metallica
on 1:TEXT:*kõrge maastikukultuur*:#:/. timer 1 %ttvtime msg # mägi
on 1:TEXT:*film*fast*furious*lavastaja*:#:/. timer 1 %ttvtime msg # rob cohen
on 1:TEXT:*lugu*disco disco*:#:/. timer 1 %ttvtime msg # mabel
on 1:TEXT:*laul*broken home*:#:/. timer 1 %ttvtime msg # papa roach
on 1:TEXT:*kaks kikkis*neli tippis*suur*keskel*:#:/. timer 1 %ttvtime msg # kass
on 1:TEXT:*element*8*:#:/. timer 1 %ttvtime msg # o
on 1:TEXT:*mitu*värvi*tshehhi*lipul*:#:/. timer 1 %ttvtime msg # kolm
on 1:TEXT:*mitu*sekundit*10*minut*:#:/. timer 1 %ttvtime msg # 600
on 1:TEXT:*kelle*teos*une*rannakülas*:#:/. timer 1 %ttvtime msg # dagmar normet
on 1:TEXT:*element*1*:#:/. timer 1 %ttvtime msg # h
on 1:TEXT:*laul*fire*:#:/. timer 1 %ttvtime msg # scooter
on 1:TEXT:*jaapan*pealinn*:#:/. timer 1 %ttvtime msg # tokyo
on 1:TEXT:*lugu*the inevitable return*great*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*soome*pealinn*:#:/. timer 1 %ttvtime msg # helsingi
on 1:TEXT:*saku*õlletehas*:#:/. timer 1 %ttvtime msg # saku
on 1:TEXT:*inglismaa*pealinn*:#:/. timer 1 %ttvtime msg # london
on 1:TEXT:*lugu*torm*:#:/. timer 1 %ttvtime msg # terminaator
on 1:TEXT:*nädalapäev*1*mai*2001*:#:/. timer 1 %ttvtime msg # teisipäev
on 1:TEXT:*kes*kaitseväe*juhataja*:#:/. timer 1 %ttvtime msg # kõuts
on 1:TEXT:*lugu*amazing*:#:/. timer 1 %ttvtime msg # madonna
on 1:TEXT:*mis*mobiil*telefone*firma*:#:/. timer 1 %ttvtime msg # nokia
on 1:TEXT:*kui suur*alma*rasvasisaldus*:#:/. timer 1 %ttvtime msg # 2,5%
on 1:TEXT:*kui palju*maal*veest*soolane*:#:/. timer 1 %ttvtime msg # 94%
on 1:TEXT:*suunakood*paide*:#:/. timer 1 %ttvtime msg # 038
on 1:TEXT:*lugu*beyond time*:#:/. timer 1 %ttvtime msg # blank&jones
on 1:TEXT:*mitu klassi*keskkoolis*:#:/. timer 1 %ttvtime msg # 12
on 1:TEXT:*eestis*10*saar*:#:/. timer 1 %ttvtime msg # ruhnu
on 1:TEXT:*hädaabi number*:#:/. timer 1 %ttvtime msg # 112
on 1:TEXT:*sügav*rõuge suurjärv*:#:/. timer 1 %ttvtime msg # 38 m
on 1:TEXT:*maailma*väik*asi*:#:/. timer 1 %ttvtime msg # kükitav mannatera
on 1:TEXT:*mis riikides*jalg*mm*2002*:#:/. timer 1 %ttvtime msg # jaapan ja korea
on 1:TEXT:*kes leiutas dünamiidi*:#:/. timer 1 %ttvtime msg # alfred nobel
on 1:TEXT:*lugu*we will survive*:#:/. timer 1 %ttvtime msg # warp brothers
on 1:TEXT:*kui*vanalt*suitsu*:#:/. timer 1 %ttvtime msg # 18
on 1:TEXT:*laul*in*bloom*:#:/. timer 1 %ttvtime msg # nirvana
on 1:TEXT:*toode*cocio*on*:#:/. timer 1 %ttvtime msg # joodav
on 1:TEXT:*kolmnurga*pikim*külg*:#:/. timer 1 %ttvtime msg # hüpotenuus
on 1:TEXT:*linn*saku*lletehas*:#:/. timer 1 %ttvtime msg # saku
on 1:TEXT:*riigilipp*üleni*roheline*:#:/. timer 1 %ttvtime msg # liibüa
on 1:TEXT:*klassikaline*rock*laul*paint it black*:#:/. timer 1 %ttvtime msg # rolling stones
on 1:TEXT:*tele2*numb*komb*:#:/. timer 1 %ttvtime msg # 055
on 1:TEXT:*laul*because*got*high*:#:/. timer 1 %ttvtime msg # afroman
on 1:TEXT:*laul*angel?*:#:/. timer 1 %ttvtime msg # shaggy
on 1:TEXT:*the*red dot com*:#:/. timer 1 %ttvtime msg # microlink
on 1:TEXT:*kus*maail*vanim*raamatukogu*:#:/. timer 1 %ttvtime msg # pariisis
on 1:TEXT:*väikesed tüdrukud*tehtud*:#:/. timer 1 %ttvtime msg # maasikavahust
on 1:TEXT:*mida*lehmad*joovad*:#:/. timer 1 %ttvtime msg # vett
on 1:TEXT:*lugu*bohem*rhaps*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*kui kõrge*himaalaja*:#:/. timer 1 %ttvtime msg # 8848 meetrit
on 1:TEXT:*mis*aastal*toomas*leius*noor*:#:/. timer 1 %ttvtime msg # 1959
on 1:TEXT:*mis*aastal*psühhoanalüüs*:#:/. timer 1 %ttvtime msg # 1917
on 1:TEXT:*mis*eesti*külgede*suhe*:#:/. timer 1 %ttvtime msg # 7:11
on 1:TEXT:*mis*maa*auto*toyota*:#:/. timer 1 %ttvtime msg # jaapan
on 1:TEXT:*lugu*rikutud*süda*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*linn*esimene*laulupidu*:#:/. timer 1 %ttvtime msg # tartu
on 1:TEXT:*lugu*why does*heart feel so bad*:#:/. timer 1 %ttvtime msg # moby
on 1:TEXT:*suunakood*haapsa*:#:/. timer 1 %ttvtime msg # 047
on 1:TEXT:*laul*oh carol*:#:/. timer 1 %ttvtime msg # smokie
on 1:TEXT:*kuidas*nim*rooma*armsuse*:#:/. timer 1 %ttvtime msg # kariidid
on 1:TEXT:*mis rahulepingule*alla*2.veebr*1920*:#:/. timer 1 %ttvtime msg # tartu
on 1:TEXT:*mitu*eksamit*põhikooli lõpetaja*:#:/. timer 1 %ttvtime msg # 3
on 1:TEXT:*lugu*nothing comp*2*you*:#:/. timer 1 %ttvtime msg # sinead o connor
on 1:TEXT:*laul*beacuse*i*got*high*:#:/. timer 1 %ttvtime msg # afroman
on 1:TEXT:*võrumaa*keskus*:#:/. timer 1 %ttvtime msg # võru
on 1:TEXT:*mida saab teha*mitte*mill*:#:/. timer 1 %ttvtime msg # kõike
on 1:TEXT:*kelle*laul*teenage dirtbag*:#:/. timer 1 %ttvtime msg # wheatus
on 1:TEXT:*kel*in the death cell*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*kes*eesti*esimene*president*:#:/. timer 1 %ttvtime msg # päts
on 1:TEXT:*kus kasvavad*lilled*harilikult*:#:/. timer 1 %ttvtime msg # varre otsas
on 1:TEXT:*küsimus,*millele on vastus ?*:#:/. timer 1 %ttvtime msg # ma ei tea
on 1:TEXT:*saaremaa*keskus*:#:/. timer 1 %ttvtime msg # kuressaare
on 1:TEXT:*üks*ööpäev on*:#:/. timer 1 %ttvtime msg # 24 tundi
on 1:TEXT:*mis*maa*auto*moskvits*:#:/. timer 1 %ttvtime msg # venemaa
on 1:TEXT:*eesti rahvastikuminister*2001*:#:/. timer 1 %ttvtime msg # katrin saks
on 1:TEXT:*üks tund on*:#:/. timer 1 %ttvtime msg # 60 minutit
on 1:TEXT:*mitu*kord*scooter*kül*eestimaad*:#:/. timer 1 %ttvtime msg # 5
on 1:TEXT:*kõige sagedasem tegus*proosas*:#:/. timer 1 %ttvtime msg # olema
on 1:TEXT:*laul*moskva*lähistel*:#:/. timer 1 %ttvtime msg # vennaskond
on 1:TEXT:*lugu*samb adagio*:#:/. timer 1 %ttvtime msg # safri duo
on 1:TEXT:*millises*riigis*samas*abie*:#:/. timer 1 %ttvtime msg # holland
on 1:TEXT:*mitu*maakonda*eestis*1998*:#:/. timer 1 %ttvtime msg # 15
on 1:TEXT:*lugu*hell yeah*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*laul*ma viies ratas*all*:#:/. timer 1 %ttvtime msg # maie parrik
on 1:TEXT:*tähtkuju*21*märts*:#:/. timer 1 %ttvtime msg # jäär
on 1:TEXT:*mis riik asub roomas*:#:/. timer 1 %ttvtime msg # vatikan
on 1:TEXT:*loom*pika kaelaga*:#:/. timer 1 %ttvtime msg # kaelkirjak
on 1:TEXT:*millal*rahareform eestis*:#:/. timer 1 %ttvtime msg # 1992
on 1:TEXT:*eesti pindala*ruutk*:#:/. timer 1 %ttvtime msg # 45215
on 1:TEXT:*wolksvagen*passat*:#:/. timer 1 %ttvtime msg # üle oma klassi
on 1:TEXT:*tähtkuju*21.detsember*:#:/. timer 1 %ttvtime msg # kaljukits
on 1:TEXT:*mitu*tuplat*kastis*:#:/. timer 1 %ttvtime msg # 50
on 1:TEXT:*eesti*rahvuslill*:#:/. timer 1 %ttvtime msg # rukkilill
on 1:TEXT:*tähtkuju*22.juuni*:#:/. timer 1 %ttvtime msg # vähk
on 1:TEXT:*lugu*whiskey in the jar*:#:/. timer 1 %ttvtime msg # metallica
on 1:TEXT:*kes*on*f1*5*kordne*maailmameister*:#:/. timer 1 %ttvtime msg # j.m.fangio
on 1:TEXT:*mitu*planeeti*meie*päikesesüsteemis*:#:/. timer 1 %ttvtime msg # 9
on 1:TEXT:*keda*kujutatud*500*kroon*:#:/. timer 1 %ttvtime msg # carl robert jakobson
on 1:TEXT:*mitmenda*eluaastani*koolis*käima*:#:/. timer 1 %ttvtime msg # 17
on 1:TEXT:*tähtkuju*21*dets*:#:/. timer 1 %ttvtime msg # kaljukits
on 1:TEXT:*mis on lennart mer*täis*nimi*:#:/. timer 1 %ttvtime msg # lennart georg meri
on 1:TEXT:*üks*tund on*:#:/. timer 1 %ttvtime msg # 60 minutit
on 1:TEXT:*lugu*in the space capsule*:#:/. timer 1 %ttvtime msg # queen
on 1:TEXT:*lugu*sorrow*:#:/. timer 1 %ttvtime msg # smilers
on 1:TEXT:*üks*minut on*:#:/. timer 1 %ttvtime msg # 60 sekundit
on 1:TEXT:*three point one hour*:#:/. timer 1 %ttvtime msg # bloodhound gang
on 1:TEXT:*snicker*paberit*saada*footbag*:#:/. timer 1 %ttvtime msg # 10
on 1:TEXT:*mis toimus*6*dets*1917*:#:/. timer 1 %ttvtime msg # soome iseseisvumine
on 1:TEXT:*mis*arv*c ?*:#:/. timer 1 %ttvtime msg # 100
on 1:TEXT:*mis*scotish*leader*:#:/. timer 1 %ttvtime msg # viski
on 1:TEXT:*mis*aastal*esimesed*värvi*tv*:#:/. timer 1 %ttvtime msg # 1955


#autovastajaviiv end
