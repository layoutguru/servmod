<{include file="header.tpl"}>
<body style="font-size: 1.2rem !important; width: 210mm; max-width: 100%; margin: auto;" onLoad="javascript: window.print();">

<{if $_ticketStatusTitle eq 'Odprt | nalepka'}>

<div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell;border-bottom: 1px solid #111;padding: 5px 3px;width: 50%;justify-content: center;vertical-align: middle;align-content: center;text-align: center;align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[si_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;border-bottom: 1px solid #111;padding: 5px 3px;margin-top: 2px;justify-content: center;vertical-align: middle;align-content: center;text-align: center;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[si_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[si_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[si_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%;" align="right"><b><b style="color: #111; text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
    <td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[si_f_ordernotes]}></b></span></td>
</tr>
        </table>
<hr style="border: 0; border-top: 1px solid #111;">
<div class="ticketpostleft" style="font-size: 1rem !important;">
    <{foreach key=key item=_item from=$_ticketPost}>
    <div class="ticketpostright" style="font-size: 1rem !important;">
        <div style="width: 100%; font-size: 1.2rem !important; min-height: 65px; padding-left: 5px;"><span style="text-transform: uppercase;"><b><{$_language[si_f_errordescsh]}>&nbsp</b><span style="text-transform: uppercase;"><{$_item[contents]}></span></span></div>
    </div>
    <{/foreach}>
</div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Poslan v zunanji servis'}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<img align="center" width="100%" src="https://www.kron.si/servis/glava.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; color: #111; background-color: #f1f1f1; font-size: 1.4rem;">
            <b><{$_language[si_f_ticketid]}></b><span style="color: #000;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b>Kontakt: | Contact:</b> <span style="text-transform: uppercase;">Kron IT, d.o.o.</span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b>Serijska številka | IMEI naprave: | Serial Number / IMEI:</b> <span style="text-transform: uppercase;"> <{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b>Naslov | Address:</b> <span style="text-transform: uppercase;"> Zagrebška cesta 83a, 2000 Maribor, Slovenia </span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b>Delovni nalog odprt v: | Workoder opened on:</b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b>ID za ddv | VAT ID:</b> SI54532540</td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b>Delovni nalog zaključen v: | Workorder closed on:</b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b>Telefonska številka | Contact Phone Nr.:</b> +386 30 685 808</td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><b>Email naslov | Contact Email address:</b> vprasanja@kron.si</b></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
    <{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
    <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{$_item[creator]}>:</b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
    </table>
</div>
<{/foreach}>
<br>
<div style="font-size: 1.4rem;border: 2px solid #111;color: #4377d1;background-color: #f5f5f5;border-radius: 10px;margin: 0px 10px 10px 10px;padding: 10px;text-align: center;">PROSIMO UPORABITE EMAIL <b>VPRASANJA@KRON.SI</b> KOT PRIMARNI KONTAKT: VPRASANJA@KRON.SI<br>PLEASE USE EMAIL <b>VPRASANJA@KRON.SI</b> AS PRIMARY CONTACT WITH US.</div>
<table style="background-color: #faff8a; text-transform: none !important; font-size: 1.1rem !important; width: 98%; font-weight: 400; border: 2px solid #000; padding: 5px; margin: 0px 10px; border-radius: 10px;">
  <tr>
    <td align="left" width="50%" style="padding-bottom: 5px; font-size: 1.2rem !important;">
      <div style="font-weight: bold; text-decoration: underline; color: #2857a8;">NAVODILA ZA ZUNANJI SERVIS:</div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px; font-size: 1.2rem !important;">
      <div style="font-weight: bold; text-decoration: underline; color: #2857a8;">INSTRUCTIONS FOR SERVICE:</div>
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="font-weight: 400; margin-right: 10px;">
      1. Ponudbo za popravilo pošljite na email <b>ponudbe@kron.si</b>.
    </td>
    <td align="right" width="50%" style="font-weight: 400; padding-bottom: 5px;">
      1. Send repair offers to email: <b>ponudbe@kron.si</b>.
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="font-weight: 400; margin-right: 10px;">
      2. Vsi rezervni deli se <b>morajo</b> vrniti nazaj s popravljenim aparatom.
    </td>
    <td align="right" width="50%" style="font-weight: 400; padding-bottom: 5px;">
      2. All replaced spare parts <b>have to be returned with the device.</b>
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="font-weight: 400; margin-right: 10px;">
      3. Na številki ponudbe mora biti <b>nujno naveden ClaimID.</b>
    </td>
    <td align="right" width="50%" style="font-weight: 400;">
       3. Please use our reference <b>CLAIM ID as your reference.</b>
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="font-weight: 400; margin-right: 10px;">
      4. V primeru, da rezervni del ni dobavljiv nas prosim obvestite na email: <b>ponudbe@kron.si.</b>
    </td>
    <td align="right" width="50%" style="font-weight: 400;">
      4. <b>If spare parts are not in stock, please inform us of the repair time by email to:</b> ponudbe@kron.si.
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="margin-right: 10px;">
      5. Pazite na podatke od strank. <b>V kolikor je na nalogu navedeno, prosim ohranite podatke.</b>
    </td>
    <td align="right" width="50%" style="">
      5. <b>Don't delete any customer data without prior consultation with us.</b>
    </td>
  </tr>
  <tr>
    <td align="left" width="50%" style="margin-right: 10px;">
      6. Račun pošljite v PDF obliki po na email: <b>RACUNI@KRON.SI</b>
    </td>
    <td align="right" width="50%" style="">
      6. Send invoices per email in PDF form to: <b>RACUNI@KRON.SI</b>
    </td>
  </tr>
</table>
</div>
<br>
<div class="clearer"></div>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr>
            <td align="center" valign="top" width="50%"><b>Podpis in žig: | Signature and Stamp:</b></td>
            <td align="center"><b>Podpis servisa | Service Signature</b></td>
        </tr>
        <tr>
            <td align="center"><img align="center" width="170px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center"><{$_podpis}></td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
</div>
</div>
<{/if}>

<{if ($_ticketStatusTitle eq 'Odprt' || $_ticketStatusTitle eq 'Ni v portalu' || $_ticketStatusTitle eq 'FMI vklopljen' || $_ticketStatusTitle eq 'Čakamo rez. dele' || $_ticketStatusTitle eq 'Čakamo odobritev' || $_ticketStatusTitle eq 'Diagnostika') && ($_userGroupID eq '1' || $_userGroupID eq '2')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[si_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glava.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[si_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[si_f_errordescsh]}><{else}><{$_language[si_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[si_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garancija:</b> Velja ob predložitvi potrjenega garancijskega lista ali originalnega računa.</li>
    <li><b>Spremembe rokov izvedbe:</b> Vsako obvestilo servisa, ne glede na to, ali je podano po telefonu, e-pošti, SMS-u ali priporočeni pošti, uradno spreminja dogovorjeni rok izvedbe.</li>
    <li><b>Deaktivacija Apple Find My, ipd.:</b> Stranka mora pred servisiranjem izklopiti funkcijo Find My ali podobno. Če to ni storjeno, se naprava vrne brez obravnave in na njen strošek.</li>
    <li><b>Cenik:</b> Stranka potrjuje, da je seznanjena z veljavnim cenikom, dostopnim na: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
    <li><b>Zadržanje zamenjanih delov:</b> Servis obdrži vse zamenjane dele brez nadomestila.</li>
    <li><b>Neprevzem naprave:</b> Če stranka naprave ne prevzame v 15 dneh po obvestilu o končanem servisu, se ji zaračuna skladiščenje po ceniku.</li>
    <li><b>Lastništvo neprevzete naprave:</b> Če stranka naprave ne prevzame v treh mesecih, naprava preide v last servisa.</li>
    <li><b>Plačilo storitev:</b> Stroški servisa morajo biti poravnani pred prevzemom naprave, razen če je drugače dogovorjeno s pogodbo ali drugim dokumentom.</li>
    <li><b>Popravilo dodatnih okvar:</b> Stranka servisu dovoljuje, da popravi vse dodatne okvare, ugotovljene med servisiranjem.</li>
    <li><b>Neporavnane obveznosti:</b> Servis lahko zadrži opremo, dokler niso poravnane vse finančne obveznosti. Če obveznosti niso poravnane v treh mesecih, lahko servis opremo uniči, proda ali odstrani.</li>
    <li><b>Izključitve iz garancije:</b> Konfiguracija, instalacija in posodobitev programske opreme ter ohranjanje podatkov niso vključeni v garancijska popravila.</li>
    <li><b>Odgovornost za izgubo podatkov:</b> Servis ne prevzema odgovornosti za izgubo podatkov. Pred servisiranjem je nujno ustvariti varnostno kopijo.</li>
    <li><b>Neupravičene reklamacije:</b> V primeru neupravičene reklamacije se stranki zaračunajo stroški diagnostike in pošiljanja.</li>
    <li><b>Diagnostika izven garancije:</b> Diagnostika opreme izven garancije se zaračuna, razen če stranka odloči za popravilo.</li>
    <li><b>Garancija ne krije poškodb:</b> Poškodbe, ki niso pokrite z garancijo, ne bodo popravljene brezplačno, naprava se vrne v prvotnem stanju, če se stranka ne odloči za plačilo popravila.</li>
    <li><b>Dodatni stroški pri ponovni reklamaciji:</b> Pri ponovni reklamaciji in nestrinjanju s izvengarancijskim popravilom se zaračunajo dodatni stroški administracije in transporta v višini 30 € z DDV.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[si_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[si_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[si_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[si_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[si_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[si_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[si_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[si_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[si_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if ($_ticketStatusTitle eq 'Popravljen | Zaključen' || $_ticketStatusTitle eq 'Zamenjan | Zaključen' || $_ticketStatusTitle eq 'Vrnjen | Stranki' || $_ticketStatusTitle eq 'Vrnjen | Dobavitelju' || $_ticketStatusTitle eq 'Zaključen | Vavčer TRG' || $_ticketStatusTitle eq 'Zaključen | Vavčer' || $_ticketStatusTitle eq 'Stranka ni dosegljiva | MB' || $_ticketStatusTitle eq 'Stranka ni dosegljiva | LJ' || $_ticketStatusTitle eq 'Neskladje' || $_ticketStatusTitle eq 'Čakamo aparat' || $_ticketStatusTitle eq 'Zaključen | Os. prevzem MB' || $_ticketStatusTitle eq 'Zaključen | Os. prevzem LJ' || $_ticketStatusTitle eq 'Lamie poslani' || $_ticketStatusTitle eq 'V popravilu' || $_ticketStatusTitle eq 'Vrnjen | Poslan nazaj' || $_ticketStatusTitle eq 'Zaključen / Dobropis' || $_ticketStatusTitle eq 'Zamenjava | Hisense' || $_ticketStatusTitle eq 'Ponudba potrjena' || $_ticketStatusTitle eq 'Vavčer | Za račun' || $_ticketStatusTitle eq 'Ponudba zavrnjena') && ($_userGroupID eq '1' || $_userGroupID eq '2')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<img align="center" width="100%" src="https://www.kron.si/servis/glava.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[si_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[si_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[si_f_errordescsh]}><{else}><{$_language[si_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[si_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garancija:</b> Velja ob predložitvi potrjenega garancijskega lista ali originalnega računa.</li>
    <li><b>Spremembe rokov izvedbe:</b> Vsako obvestilo servisa, ne glede na to, ali je podano po telefonu, e-pošti, SMS-u ali priporočeni pošti, uradno spreminja dogovorjeni rok izvedbe.</li>
    <li><b>Deaktivacija Apple Find My, ipd.:</b> Stranka mora pred servisiranjem izklopiti funkcijo Find My ali podobno. Če to ni storjeno, se naprava vrne brez obravnave in na njen strošek.</li>
    <li><b>Cenik:</b> Stranka potrjuje, da je seznanjena z veljavnim cenikom, dostopnim na: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
    <li><b>Zadržanje zamenjanih delov:</b> Servis obdrži vse zamenjane dele brez nadomestila.</li>
    <li><b>Neprevzem naprave:</b> Če stranka naprave ne prevzame v 15 dneh po obvestilu o končanem servisu, se ji zaračuna skladiščenje po ceniku.</li>
    <li><b>Lastništvo neprevzete naprave:</b> Če stranka naprave ne prevzame v treh mesecih, naprava preide v last servisa.</li>
    <li><b>Plačilo storitev:</b> Stroški servisa morajo biti plačani pred prevzemom naprave, razen če je drugače dogovorjeno s pogodbo ali drugim dokumentom.</li>
    <li><b>Popravilo dodatnih okvar:</b> Stranka servisu dovoljuje, da popravi vse dodatne okvare, ugotovljene med servisiranjem.</li>
    <li><b>Neporavnane obveznosti:</b> Servis lahko zadrži opremo, dokler niso poravnane vse finančne obveznosti. Če obveznosti niso poravnane v treh mesecih, lahko servis opremo uniči, proda ali odstrani.</li>
    <li><b>Izključitve iz garancije:</b> Konfiguracija, instalacija in posodobitev programske opreme ter ohranjanje podatkov niso vključeni v garancijska popravila.</li>
    <li><b>Odgovornost za izgubo podatkov:</b> Servis ne prevzema odgovornosti za izgubo podatkov. Pred servisiranjem je nujno ustvariti varnostno kopijo.</li>
    <li><b>Neupravičene reklamacije:</b> V primeru neupravičene reklamacije se stranki zaračunajo stroški diagnostike in pošiljanja.</li>
    <li><b>Diagnostika izven garancije:</b> Diagnostika opreme izven garancije se zaračuna, razen če stranka odloči za popravilo.</li>
    <li><b>Garancija ne krije poškodb:</b> Poškodbe, ki niso pokrite z garancijo, ne bodo popravljene brezplačno, naprava se vrne v prvotnem stanju, če se stranka ne odloči za plačilo popravila.</li>
    <li><b>Dodatni stroški pri ponovni reklamaciji:</b> Pri ponovni reklamaciji in nestrinjanju s izvengarancijskim popravilom se zaračunajo dodatni stroški administracije in transporta v višini 30 € z DDV.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[si_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[si_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[si_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[si_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
</div>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '17' || $_userGroupID eq '18')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[en_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[en_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[en_f_errordescsh]}><{else}><{$_language[en_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[en_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Warranty:</b> Valid upon presentation of a certified warranty certificate or the original invoice.</li>
<li><b>Changes to execution deadlines:</b> Any notification from the service center, whether given by phone, email, SMS, or registered mail, officially modifies the agreed execution deadline.</li>
<li><b>Deactivation of Apple Find My, etc.:</b> The customer must disable the Find My feature or similar before servicing. If this is not done, the device will be returned without processing at the customer’s expense.</li>
<li><b>Pricing:</b> The customer confirms awareness of the applicable price list, available at: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Retention of replaced parts:</b> The service center retains all replaced parts without compensation.</li>
<li><b>Non-collection of the device:</b> If the customer does not collect the device within 15 days of notification of service completion, storage fees will be charged according to the price list.</li>
<li><b>Ownership of an unclaimed device:</b> If the customer does not collect the device within three months, ownership transfers to the service center.</li>
<li><b>Payment for services:</b> Service costs must be settled before collecting the device unless otherwise agreed upon in a contract or other document.</li>
<li><b>Repair of additional defects:</b> The customer authorizes the service center to repair any additional defects discovered during servicing.</li>
<li><b>Unsettled obligations:</b> The service center may retain the equipment until all financial obligations are settled. If obligations remain unpaid for three months, the service center may destroy, sell, or dispose of the equipment.</li>
<li><b>Exclusions from warranty:</b> Configuration, installation, software updates, and data preservation are not covered under warranty repairs.</li>
<li><b>Liability for data loss:</b> The service center assumes no responsibility for data loss. A backup must be created before servicing.</li>
<li><b>Unjustified complaints:</b> In the case of an unjustified complaint, the customer will be charged for diagnostics and shipping costs.</li>
<li><b>Out-of-warranty diagnostics:</b> Diagnostics for out-of-warranty equipment are chargeable unless the customer proceeds with the repair.</li>
<li><b>Warranty does not cover damages:</b> Damages not covered by the warranty will not be repaired free of charge. The device will be returned in its original condition unless the customer opts for a paid repair.</li>
<li><b>Additional costs for repeated complaints:</b> In the event of a repeated complaint and disagreement with an out-of-warranty repair, additional administrative and transport costs of €30 (including VAT) will be charged.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[en_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[en_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[en_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[en_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '17' || $_userGroupID eq '18')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[en_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[en_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[en_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[en_f_errordescsh]}><{else}><{$_language[en_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[en_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Warranty:</b> Valid upon presentation of a certified warranty certificate or the original invoice.</li>
<li><b>Changes to execution deadlines:</b> Any notification from the service center, whether given by phone, email, SMS, or registered mail, officially modifies the agreed execution deadline.</li>
<li><b>Deactivation of Apple Find My, etc.:</b> The customer must disable the Find My feature or similar before servicing. If this is not done, the device will be returned without processing at the customer’s expense.</li>
<li><b>Pricing:</b> The customer confirms awareness of the applicable price list, available at: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Retention of replaced parts:</b> The service center retains all replaced parts without compensation.</li>
<li><b>Non-collection of the device:</b> If the customer does not collect the device within 15 days of notification of service completion, storage fees will be charged according to the price list.</li>
<li><b>Ownership of an unclaimed device:</b> If the customer does not collect the device within three months, ownership transfers to the service center.</li>
<li><b>Payment for services:</b> Service costs must be settled before collecting the device unless otherwise agreed upon in a contract or other document.</li>
<li><b>Repair of additional defects:</b> The customer authorizes the service center to repair any additional defects discovered during servicing.</li>
<li><b>Unsettled obligations:</b> The service center may retain the equipment until all financial obligations are settled. If obligations remain unpaid for three months, the service center may destroy, sell, or dispose of the equipment.</li>
<li><b>Exclusions from warranty:</b> Configuration, installation, software updates, and data preservation are not covered under warranty repairs.</li>
<li><b>Liability for data loss:</b> The service center assumes no responsibility for data loss. A backup must be created before servicing.</li>
<li><b>Unjustified complaints:</b> In the case of an unjustified complaint, the customer will be charged for diagnostics and shipping costs.</li>
<li><b>Out-of-warranty diagnostics:</b> Diagnostics for out-of-warranty equipment are chargeable unless the customer proceeds with the repair.</li>
<li><b>Warranty does not cover damages:</b> Damages not covered by the warranty will not be repaired free of charge. The device will be returned in its original condition unless the customer opts for a paid repair.</li>
<li><b>Additional costs for repeated complaints:</b> In the event of a repeated complaint and disagreement with an out-of-warranty repair, additional administrative and transport costs of €30 (including VAT) will be charged.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[en_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[en_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[en_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[en_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
<{/if}>

<{if ($_ticketStatusTitle eq 'Vraćen | Dobavljaču' || $_ticketStatusTitle eq 'Poslan nazad' || $_ticketStatusTitle eq 'U popravki' || $_ticketStatusTitle eq 'Ćekamo partove' || $_ticketStatusTitle eq 'Fmi zakljućan' || $_ticketStatusTitle eq 'U diagnozi' || $_ticketStatusTitle eq 'Korisnik nije dosegljiv' || $_ticketStatusTitle eq 'U prihodu' || $_ticketStatusTitle eq 'Otvoren') || ($_userGroupID eq '5' || $_userGroupID eq '6')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
  <div style="display: table;">
    <div style="display:table-row;">
      <img align="center" width=100% src="https://www.kron.si/servis/glavahr.png" />
      <br>
    </div>
  </div>
  <br>
  <div style="font-size: 1.2rem !important; margin-left:10px; margin-right:10px;">
    <table style="border:0px solid #111; width: 100%;" cellspacing="1" cellpadding="3">
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <b style="color: #006699;"><{$_language[hr_f_ticketid]}></b> <{$_ticketID}>
          </div>
        </td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_customer]}></b> <{$_fullName}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_subject]}></b> <{$_ticketSubject}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_address]}></b> <{$_naslovStranke}>, <{$_postnaStevilka}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_dateopen]}></b> <{$_ticketDate}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_phone]}></b> <{$_userPhoneNumber}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hr_f_dateclosed]}></b> <{$_ticketUpdated}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
      </tr>
    </table>
  </div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[hr_f_errordescsh]}><{else}><{$_language[hr_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[hr_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Jamstvo:</b> Vrijedi uz predočenje potvrđenog jamstvenog lista ili originalnog računa.</li>
    <li><b>Promjene rokova izvršenja:</b> Svaka obavijest servisa, bez obzira je li dana telefonom, e-poštom, SMS-om ili preporučenom poštom, službeno mijenja dogovoreni rok izvršenja.</li>
    <li><b>Deaktivacija funkcije Traži moj iPhone:</b> Klijent mora prije servisiranja isključiti funkciju Traži moj iPhone. Ako to nije učinjeno, uređaj se vraća klijentu bez obrade i na njegov trošak.</li>
    <li><b>Cjenik:</b> Klijent potvrđuje da je upoznat s važećim cjenikom, dostupnim na: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
    <li><b>Zadržavanje zamijenjenih dijelova:</b> Servis zadržava sve zamijenjene dijelove bez naknade.</li>
    <li><b>Nepreuzimanje uređaja:</b> Ako klijent uređaj ne preuzme u 15 dana nakon obavijesti o završetku servisa, naplaćuje se skladištenje prema cjeniku.</li>
    <li><b>Vlasništvo nepreuzetog uređaja:</b> Ako klijent uređaj ne preuzme u tri mjeseca, uređaj prelazi u vlasništvo servisa.</li>
    <li><b>Plaćanje usluga:</b> Troškovi servisa moraju biti plaćeni prije preuzimanja uređaja, osim ako nije drugačije dogovoreno ugovorom ili drugim dokumentom.</li>
    <li><b>Popravak dodatnih kvarova:</b> Klijent dopušta servisu da popravi sve dodatne kvarove utvrđene tijekom servisiranja.</li>
    <li><b>Zadržavanje opreme zbog neplaćanja:</b> Servis može zadržati opremu dok se ne izmire sve obveze. Ako obveze nisu izmirene u tri mjeseca, servis može uništiti, prodati ili ukloniti opremu.</li>
    <li><b>Izuzimanja iz jamstva:</b> Konfiguracija, instalacija i ažuriranje softvera te očuvanje podataka nisu uključeni u jamstvene popravke.</li>
    <li><b>Odgovornost za gubitak podataka:</b> Servis ne preuzima odgovornost za gubitak podataka. Prije servisiranja nužno je stvoriti sigurnosnu kopiju.</li>
    <li><b>Neopravdane reklamacije:</b> U slučaju neopravdane reklamacije klijentu se naplaćuju troškovi dijagnostike i slanja.</li>
    <li><b>Dijagnostika izvan jamstva:</b> Dijagnostika opreme izvan jamstva se naplaćuje, osim ako klijent odluči za popravak.</li>
    <li><b>Jamstvo ne pokriva oštećenja:</b> Oštećenja koja nisu pokrivena jamstvom neće biti popravljena besplatno, uređaj se vraća u izvornom stanju, ako se klijent ne odluči za plaćanje popravka.</li>
    <li><b>Dodatni troškovi pri ponovnoj reklamaciji:</b> Pri ponovnoj reklamaciji i neslaganju s izvangarancijskim popravkom naplaćuju se dodatni troškovi administracije i transporta u iznosu od 30 € s PDV-om.</li>
</ol>
        </td>
      </tr>
    </table>
  </div>
  <br><br>
  <div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td align="center" valign="top" width="35%"><b><{$_language[hr_f_signstamp]}></b><br><img align="center" width=140px src="https://www.kron.si/servis/podp_stemp.png" /></td>
        <td align="center" valign="top" width="30%"><b><{$_language[hr_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
        <td align="center" valign="top" width="35%"><b><{$_language[hr_f_signcust]}></b><span style="text-transform: uppercase;"><{$_fullName}></span></td>
      </tr>
    </table>
    <br><br>
    <div style="width: 12cm; font-size: 1.2rem !important; text-transform: uppercase; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
      <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[hr_f_ticketidsh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11"></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[hr_f_subjectsh]}></b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sf=0.7&sy=0.12"></span></b></span></td>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;">Odprt v:</b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_ticketDate}></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[hr_f_customersh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_fullName}></span></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;">Tel. št.:</b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_userPhoneNumber}></b></span></td>
        </tr>
      </table>
      <div style="width: 100%; font-size: 1.2rem !important; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[hr_f_ordernotes]}></b><span style="text-transform: uppercase;"><br><br></span></span></div>
      <br>
    </div>
  </div>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '3' || $_userGroupID eq '4')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
  <div style="display: table;">
    <div style="display:table-row;">
      <table style="width: 100%;" cellspacing="0" cellpadding="0" font-size="13px;">
        <tr>
          <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
        </tr>
      </table>
      <img align="center" width=100% src="https://www.kron.si/servis/glavade.png" />
      <br>
    </div>
  </div>
  <br>
  <div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left:10px; margin-right:10px;">
    <table style="border:0px solid #111; width: 100%;" cellspacing="1" cellpadding="3">
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b style="color: #006699;"><{$_language[de_f_ticketid]}></b> <{$_ticketID}>
          </div>
        </td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_customer]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_phone]}></b> <{$_userPhoneNumber}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateclosed]}></b> <{$_ticketUpdated}></td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
      </tr>
    </table>
  </div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
    <hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[de_f_errordescsh]}><{else}><{$_language[de_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[de_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garantie:</b> Gültig bei Vorlage eines bestätigten Garantiescheins oder der Originalrechnung.</li>
    <li><b>Änderungen der Ausführungsfristen:</b> Jede Mitteilung des Servicecenters, unabhängig davon, ob sie telefonisch, per E-Mail, SMS oder Einschreiben erfolgt, ändert offiziell den vereinbarten Ausführungstermin.</li>
    <li><b>Deaktivierung der Funktion „Mein iPhone suchen“:</b> Der Kunde muss vor der Wartung die Funktion „Mein iPhone suchen“ deaktivieren. Ist dies nicht geschehen, wird das Gerät ohne Bearbeitung auf Kosten des Kunden zurückgesandt.</li>
    <li><b>Preisliste:</b> Der Kunde bestätigt, dass er mit der gültigen Preisliste vertraut ist, die unter: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a> zugänglich ist.</li>
    <li><b>Behalten ausgetauschter Teile:</b> Der Service behält alle ausgetauschten Teile ohne Entschädigung.</li>
    <li><b>Nichtabholung des Gerätes:</b> Wenn der Kunde das Gerät nicht innerhalb von 15 Tagen nach Mitteilung über den Abschluss des Service abholt, werden Lagergebühren gemäß der Preisliste berechnet.</li>
    <li><b>Eigentum an nicht abgeholten Geräten:</b> Wenn der Kunde das Gerät nicht innerhalb von drei Monaten abholt, geht das Gerät in das Eigentum des Service über.</li>
    <li><b>Zahlung der Dienstleistungen:</b> Die Servicekosten müssen vor der Abholung des Geräts bezahlt werden, es sei denn, es wurde vertraglich oder durch ein anderes Dokument anders vereinbart.</li>
    <li><b>Reparatur zusätzlicher Schäden:</b> Der Kunde erlaubt dem Service, alle zusätzlichen Schäden zu reparieren, die während der Wartung festgestellt werden.</li>
    <li><b>Einbehaltung von Geräten wegen Nichtzahlung:</b> Der Service kann die Geräte zurückhalten, bis alle Verpflichtungen beglichen sind. Werden die Verpflichtungen innerhalb von drei Monaten nicht erfüllt, kann der Service das Gerät vernichten, verkaufen oder entfernen.</li>
    <li><b>Ausnahmen von der Garantie:</b> Konfiguration, Installation und Aktualisierung der Software sowie die Datenerhaltung sind nicht in den Garantiereparaturen enthalten.</li>
    <li><b>Haftung für Datenverlust:</b> Der Service übernimmt keine Haftung für Datenverlust. Es ist notwendig, vor der Wartung eine Sicherungskopie zu erstellen.</li>
    <li><b>Unberechtigte Reklamationen:</b> Im Falle einer unberechtigten Reklamation werden dem Kunden die Kosten für Diagnose und Versand berechnet.</li>
    <li><b>Diagnose außerhalb der Garantie:</b> Die Diagnose von Geräten außerhalb der Garantie wird berechnet, es sei denn, der Kunde entscheidet sich für eine Reparatur.</li>
    <li><b>Garantie deckt keine Schäden:</b> Schäden, die nicht von der Garantie abgedeckt sind, werden nicht kostenlos repariert, das Gerät wird in seinem ursprünglichen Zustand zurückgegeben, wenn sich der Kunde nicht für eine bezahlte Reparatur entscheidet.</li>
    <li><b>Zusätzliche Kosten bei erneuter Reklamation:</b> Bei einer erneuten Reklamation und Nichtübereinstimmung mit einer außergarantischen Reparatur werden zusätzliche Verwaltungs- und Transportkosten in Höhe von 30 € inkl. MwSt. berechnet.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
  <div align="center" style="font-size: 1.2rem !important;"><{$_language[de_f_terms2]}></div>
  <br><br>
  <div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
      <tr>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signstamp]}></b><br><img align="center" width=140px src="https://www.kron.si/servis/podp_stemp.png" /></td>
        <td align="center" valign="top" width="30%"><b><{$_language[de_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
      </tr>
    </table>
    <br><br>
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
      <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_ticketidsh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11"></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_subjectsh]}></b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sf=0.7&sy=0.12"></span></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 50%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_dateopen]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 50%;" align="right"><b><span style="text-transform: uppercase;"><{$_ticketDate}></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_customersh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_fullName}></span></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_phone]}></b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_userPhoneNumber}></b></span></td>
        </tr>
      </table>
      <div style="width: 100%; font-size: 1.2rem !important; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b>BESTELLTE TEILE / ANMERKUNGEN:&nbsp</b><span style="text-transform: uppercase;"><br><br></span></span></div>
      <br>
    </div>
  </div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '3' || $_userGroupID eq '4')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
  <div style="display: table;">
    <div style="display:table-row;">
      <table style="width: 100%;" cellspacing="0" cellpadding="0" font-size="13px;">
        <tr>
          <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
        </tr>
      </table>
      <img align="center" width=100% src="https://www.kron.si/servis/glavade.png" />
      <br>
    </div>
  </div>
  <br>
  <div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left:10px; margin-right:10px;">
    <table style="border:0px solid #111; width: 100%;" cellspacing="1" cellpadding="3">
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b style="color: #006699;"><{$_language[de_f_ticketid]}></b> <{$_ticketID}>
          </div>
        </td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_customer]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_phone]}></b> <{$_userPhoneNumber}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateclosed]}></b> <{$_ticketUpdated}></td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
      </tr>
    </table>
  </div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
    <hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[de_f_errordescsh]}><{else}><{$_language[de_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[de_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garantie:</b> Gültig bei Vorlage eines bestätigten Garantiescheins oder der Originalrechnung.</li>
    <li><b>Änderungen der Ausführungsfristen:</b> Jede Mitteilung des Servicecenters, unabhängig davon, ob sie telefonisch, per E-Mail, SMS oder Einschreiben erfolgt, ändert offiziell den vereinbarten Ausführungstermin.</li>
    <li><b>Deaktivierung der Funktion „Mein iPhone suchen“:</b> Der Kunde muss vor der Wartung die Funktion „Mein iPhone suchen“ deaktivieren. Ist dies nicht geschehen, wird das Gerät ohne Bearbeitung auf Kosten des Kunden zurückgesandt.</li>
    <li><b>Preisliste:</b> Der Kunde bestätigt, dass er mit der gültigen Preisliste vertraut ist, die unter: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a> zugänglich ist.</li>
    <li><b>Behalten ausgetauschter Teile:</b> Der Service behält alle ausgetauschten Teile ohne Entschädigung.</li>
    <li><b>Nichtabholung des Gerätes:</b> Wenn der Kunde das Gerät nicht innerhalb von 15 Tagen nach Mitteilung über den Abschluss des Service abholt, werden Lagergebühren gemäß der Preisliste berechnet.</li>
    <li><b>Eigentum an nicht abgeholten Geräten:</b> Wenn der Kunde das Gerät nicht innerhalb von drei Monaten abholt, geht das Gerät in das Eigentum des Service über.</li>
    <li><b>Zahlung der Dienstleistungen:</b> Die Servicekosten müssen vor der Abholung des Geräts bezahlt werden, es sei denn, es wurde vertraglich oder durch ein anderes Dokument anders vereinbart.</li>
    <li><b>Reparatur zusätzlicher Schäden:</b> Der Kunde erlaubt dem Service, alle zusätzlichen Schäden zu reparieren, die während der Wartung festgestellt werden.</li>
    <li><b>Einbehaltung von Geräten wegen Nichtzahlung:</b> Der Service kann die Geräte zurückhalten, bis alle Verpflichtungen beglichen sind. Werden die Verpflichtungen innerhalb von drei Monaten nicht erfüllt, kann der Service das Gerät vernichten, verkaufen oder entfernen.</li>
    <li><b>Ausnahmen von der Garantie:</b> Konfiguration, Installation und Aktualisierung der Software sowie die Datenerhaltung sind nicht in den Garantiereparaturen enthalten.</li>
    <li><b>Haftung für Datenverlust:</b> Der Service übernimmt keine Haftung für Datenverlust. Es ist notwendig, vor der Wartung eine Sicherungskopie zu erstellen.</li>
    <li><b>Unberechtigte Reklamationen:</b> Im Falle einer unberechtigten Reklamation werden dem Kunden die Kosten für Diagnose und Versand berechnet.</li>
    <li><b>Diagnose außerhalb der Garantie:</b> Die Diagnose von Geräten außerhalb der Garantie wird berechnet, es sei denn, der Kunde entscheidet sich für eine Reparatur.</li>
    <li><b>Garantie deckt keine Schäden:</b> Schäden, die nicht von der Garantie abgedeckt sind, werden nicht kostenlos repariert, das Gerät wird in seinem ursprünglichen Zustand zurückgegeben, wenn sich der Kunde nicht für eine bezahlte Reparatur entscheidet.</li>
    <li><b>Zusätzliche Kosten bei erneuter Reklamation:</b> Bei einer erneuten Reklamation und Nichtübereinstimmung mit einer außergarantischen Reparatur werden zusätzliche Verwaltungs- und Transportkosten in Höhe von 30 € inkl. MwSt. berechnet.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
  <div align="center" style="font-size: 1.2rem !important;"><{$_language[de_f_terms2]}></div>
  <br><br>
  <div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
      <tr>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signstamp]}></b><br><img align="center" width=140px src="https://www.kron.si/servis/podp_stemp.png" /></td>
        <td align="center" valign="top" width="30%"><b><{$_language[de_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
      </tr>
    </table>
<{/if}>

<{if ($_ticketStatusTitle eq 'Offen' || $_ticketStatusTitle eq 'In der Ankunft') && ($_userGroupID eq '3' || $_userGroupID eq '4')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
  <div style="display: table;">
    <div style="display:table-row;">
      <table style="width: 100%;" cellspacing="0" cellpadding="0" font-size="13px;">
        <tr>
          <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
        </tr>
      </table>
      <img align="center" width=100% src="https://www.kron.si/servis/glavade.png" />
      <br>
    </div>
  </div>
  <br>
  <div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left:10px; margin-right:10px;">
    <table style="border:0px solid #111; width: 100%;" cellspacing="1" cellpadding="3">
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b style="color: #006699;"><{$_language[de_f_ticketid]}></b> <{$_ticketID}>
          </div>
        </td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_customer]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_phone]}></b> <{$_userPhoneNumber}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateclosed]}></b> <{$_ticketUpdated}></td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
      </tr>
    </table>
  </div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
    <hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[de_f_errordescsh]}><{else}><{$_language[de_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[de_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garantie:</b> Gültig bei Vorlage eines bestätigten Garantiescheins oder der Originalrechnung.</li>
    <li><b>Änderungen der Ausführungsfristen:</b> Jede Mitteilung des Servicecenters, unabhängig davon, ob sie telefonisch, per E-Mail, SMS oder Einschreiben erfolgt, ändert offiziell den vereinbarten Ausführungstermin.</li>
    <li><b>Deaktivierung der Funktion „Mein iPhone suchen“:</b> Der Kunde muss vor der Wartung die Funktion „Mein iPhone suchen“ deaktivieren. Ist dies nicht geschehen, wird das Gerät ohne Bearbeitung auf Kosten des Kunden zurückgesandt.</li>
    <li><b>Preisliste:</b> Der Kunde bestätigt, dass er mit der gültigen Preisliste vertraut ist, die unter: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a> zugänglich ist.</li>
    <li><b>Behalten ausgetauschter Teile:</b> Der Service behält alle ausgetauschten Teile ohne Entschädigung.</li>
    <li><b>Nichtabholung des Gerätes:</b> Wenn der Kunde das Gerät nicht innerhalb von 15 Tagen nach Mitteilung über den Abschluss des Service abholt, werden Lagergebühren gemäß der Preisliste berechnet.</li>
    <li><b>Eigentum an nicht abgeholten Geräten:</b> Wenn der Kunde das Gerät nicht innerhalb von drei Monaten abholt, geht das Gerät in das Eigentum des Service über.</li>
    <li><b>Zahlung der Dienstleistungen:</b> Die Servicekosten müssen vor der Abholung des Geräts bezahlt werden, es sei denn, es wurde vertraglich oder durch ein anderes Dokument anders vereinbart.</li>
    <li><b>Reparatur zusätzlicher Schäden:</b> Der Kunde erlaubt dem Service, alle zusätzlichen Schäden zu reparieren, die während der Wartung festgestellt werden.</li>
    <li><b>Einbehaltung von Geräten wegen Nichtzahlung:</b> Der Service kann die Geräte zurückhalten, bis alle Verpflichtungen beglichen sind. Werden die Verpflichtungen innerhalb von drei Monaten nicht erfüllt, kann der Service das Gerät vernichten, verkaufen oder entfernen.</li>
    <li><b>Ausnahmen von der Garantie:</b> Konfiguration, Installation und Aktualisierung der Software sowie die Datenerhaltung sind nicht in den Garantiereparaturen enthalten.</li>
    <li><b>Haftung für Datenverlust:</b> Der Service übernimmt keine Haftung für Datenverlust. Es ist notwendig, vor der Wartung eine Sicherungskopie zu erstellen.</li>
    <li><b>Unberechtigte Reklamationen:</b> Im Falle einer unberechtigten Reklamation werden dem Kunden die Kosten für Diagnose und Versand berechnet.</li>
    <li><b>Diagnose außerhalb der Garantie:</b> Die Diagnose von Geräten außerhalb der Garantie wird berechnet, es sei denn, der Kunde entscheidet sich für eine Reparatur.</li>
    <li><b>Garantie deckt keine Schäden:</b> Schäden, die nicht von der Garantie abgedeckt sind, werden nicht kostenlos repariert, das Gerät wird in seinem ursprünglichen Zustand zurückgegeben, wenn sich der Kunde nicht für eine bezahlte Reparatur entscheidet.</li>
    <li><b>Zusätzliche Kosten bei erneuter Reklamation:</b> Bei einer erneuten Reklamation und Nichtübereinstimmung mit einer außergarantischen Reparatur werden zusätzliche Verwaltungs- und Transportkosten in Höhe von 30 € inkl. MwSt. berechnet.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
  <div align="center" style="font-size: 1.2rem !important;"><{$_language[de_f_terms2]}></div>
  <br><br>
  <div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
      <tr>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signstamp]}></b><br><img align="center" width=140px src="https://www.kron.si/servis/podp_stemp.png" /></td>
        <td align="center" valign="top" width="30%"><b><{$_language[de_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
      </tr>
    </table>
    <br><br>
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
      <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_ticketidsh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11"></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_subjectsh]}></b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sf=0.7&sy=0.12"></span></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 50%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_dateopen]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 50%;" align="right"><b><span style="text-transform: uppercase;"><{$_ticketDate}></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_customersh]}></b></span></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_fullName}></span></b></span></td>
        </tr>
        <tr>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 30%;" align="left"><b><span style="text-transform: uppercase;"><{$_language[de_f_phone]}></b></td>
          <td style="border-bottom: 1px solid #111; padding: 2px; padding-left: 3px; padding-right: 3px; width: 70%;" align="right"><b><span style="text-transform: uppercase;"><{$_userPhoneNumber}></b></span></td>
        </tr>
      </table>
      <div style="width: 100%; font-size: 1.2rem !important; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b>BESTELLTE TEILE / ANMERKUNGEN:&nbsp</b><span style="text-transform: uppercase;"><br><br></span></span></div>
      <br>
    </div>
  </div>
<{/if}>

<{if ($_ticketStatusTitle eq 'Zurückgeschickt' || $_ticketStatusTitle eq 'Diagnostik' || $_ticketStatusTitle eq 'Final Test' || $_ticketStatusTitle eq 'Phone Lock' || $_ticketStatusTitle eq 'Neugerät bestellt' || $_ticketStatusTitle eq 'Totalschaden') && ($_userGroupID eq '3' || $_userGroupID eq '4')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
  <div style="display: table;">
    <div style="display:table-row;">
      <table style="width: 100%;" cellspacing="0" cellpadding="0" font-size="13px;">
        <tr>
          <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
        </tr>
      </table>
      <img align="center" width=100% src="https://www.kron.si/servis/glavade.png" />
      <br>
    </div>
  </div>
  <br>
  <div style="font-size: 1.2rem !important; color: #111; background-color: #fff; margin-left:10px; margin-right:10px;">
    <table style="border:0px solid #111; width: 100%;" cellspacing="1" cellpadding="3">
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b style="color: #006699;"><{$_language[de_f_ticketid]}></b> <{$_ticketID}>
          </div>
        </td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateopen]}></b> <{$_ticketDate}></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_phone]}></b> <{$_userPhoneNumber}></td>
        <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[de_f_dateclosed]}></b> <{$_ticketUpdated}></td>
      </tr>
      <tr>
        <td colspan="2"></td>
      </tr>
      <tr>
        <td align="left" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
        <td align="right" width="50%" style="padding-bottom: 5px;">
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
          &nbsp;&nbsp;
          <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
          </div>
        </td>
      </tr>
    </table>
  </div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
    <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[de_f_errordescsh]}><{else}><{$_language[de_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<br>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[de_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
    <li><b>Garantie:</b> Gültig bei Vorlage eines bestätigten Garantiescheins oder der Originalrechnung.</li>
    <li><b>Änderungen der Ausführungsfristen:</b> Jede Mitteilung des Servicecenters, unabhängig davon, ob sie telefonisch, per E-Mail, SMS oder Einschreiben erfolgt, ändert offiziell den vereinbarten Ausführungstermin.</li>
    <li><b>Deaktivierung der Funktion „Mein iPhone suchen“:</b> Der Kunde muss vor der Wartung die Funktion „Mein iPhone suchen“ deaktivieren. Ist dies nicht geschehen, wird das Gerät ohne Bearbeitung auf Kosten des Kunden zurückgesandt.</li>
    <li><b>Preisliste:</b> Der Kunde bestätigt, dass er mit der gültigen Preisliste vertraut ist, die unter: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a> zugänglich ist.</li>
    <li><b>Behalten ausgetauschter Teile:</b> Der Service behält alle ausgetauschten Teile ohne Entschädigung.</li>
    <li><b>Nichtabholung des Gerätes:</b> Wenn der Kunde das Gerät nicht innerhalb von 15 Tagen nach Mitteilung über den Abschluss des Service abholt, werden Lagergebühren gemäß der Preisliste berechnet.</li>
    <li><b>Eigentum an nicht abgeholten Geräten:</b> Wenn der Kunde das Gerät nicht innerhalb von drei Monaten abholt, geht das Gerät in das Eigentum des Service über.</li>
    <li><b>Zahlung der Dienstleistungen:</b> Die Servicekosten müssen vor der Abholung des Geräts bezahlt werden, es sei denn, es wurde vertraglich oder durch ein anderes Dokument anders vereinbart.</li>
    <li><b>Reparatur zusätzlicher Schäden:</b> Der Kunde erlaubt dem Service, alle zusätzlichen Schäden zu reparieren, die während der Wartung festgestellt werden.</li>
    <li><b>Einbehaltung von Geräten wegen Nichtzahlung:</b> Der Service kann die Geräte zurückhalten, bis alle Verpflichtungen beglichen sind. Werden die Verpflichtungen innerhalb von drei Monaten nicht erfüllt, kann der Service das Gerät vernichten, verkaufen oder entfernen.</li>
    <li><b>Ausnahmen von der Garantie:</b> Konfiguration, Installation und Aktualisierung der Software sowie die Datenerhaltung sind nicht in den Garantiereparaturen enthalten.</li>
    <li><b>Haftung für Datenverlust:</b> Der Service übernimmt keine Haftung für Datenverlust. Es ist notwendig, vor der Wartung eine Sicherungskopie zu erstellen.</li>
    <li><b>Unberechtigte Reklamationen:</b> Im Falle einer unberechtigten Reklamation werden dem Kunden die Kosten für Diagnose und Versand berechnet.</li>
    <li><b>Diagnose außerhalb der Garantie:</b> Die Diagnose von Geräten außerhalb der Garantie wird berechnet, es sei denn, der Kunde entscheidet sich für eine Reparatur.</li>
    <li><b>Garantie deckt keine Schäden:</b> Schäden, die nicht von der Garantie abgedeckt sind, werden nicht kostenlos repariert, das Gerät wird in seinem ursprünglichen Zustand zurückgegeben, wenn sich der Kunde nicht für eine bezahlte Reparatur entscheidet.</li>
    <li><b>Zusätzliche Kosten bei erneuter Reklamation:</b> Bei einer erneuten Reklamation und Nichtübereinstimmung mit einer außergarantischen Reparatur werden zusätzliche Verwaltungs- und Transportkosten in Höhe von 30 € inkl. MwSt. berechnet.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
  <div align="center" style="font-size: 1.2rem !important;"><{$_language[de_f_terms2]}></div>
  <br><br>
  <div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
      <tr>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signstamp]}></b><br><img align="center" width=140px src="https://www.kron.si/servis/podp_stemp.png" /></td>
        <td align="center" valign="top" width="30%"><b><{$_language[de_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
        <td align="center" valign="top" width="35%"><b><{$_language[de_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
      </tr>
    </table>
        </div>
  </div>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '8' || $_userGroupID eq '12')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[lb_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[lb_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[lb_f_errordescsh]}><{else}><{$_language[lb_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[lb_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie:</b> Gëllt bei Virweises vun engem zertifizéierte Garantieschäin oder der Originaifaktura.</li>
<li><b>Ännerunge vun Ausféierungszäiten:</b> All Meldung vum Servicecenter, sief et per Telefon, E-Mail, SMS oder agesch Bréif, ännert offiziell déi vereinbarte Ausféierungszäit.</li>
<li><b>Desaktivatioun vun Apple Find My, asw.:</b> De Client muss d'Find My-Fonction oder ähnlech virum Service desaktivéieren. Wann dat net geschitt, gëtt den Apparat ouni Verschaffen un de Client zréckginn, op seng Käschten.</li>
<li><b>Präisgestaltung:</b> De Client bestätegt d'Kenntnis vun der gëltege Präislëscht, déi ënnert dësem Link ze fannen ass: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Bäibehale vu gewiesselte Deeler:</b> Den Servicecenter behält all gewiesselt Deeler ouni Kompensatioun.</li>
<li><b>Net-Ofhale vum Apparat:</b> Wa de Client den Apparat net bannent 15 Deeg no Meldung vum Ofschloss vum Service ofhëlt, ginn Lagerungsgebiären no der Präislëscht berechent.</li>
<li><b>Besëtz vun engem net ofgehaalen Apparat:</b> Wa de Client den Apparat net bannent dräi Méint ofhëlt, geet den Besëtz un de Servicecenter.</li>
<li><b>Bezuelen vu Servicer:</b> Servicegebiären mussen virum Ofhale vum Apparat bezuelt ginn, ausser et gëtt an engem Vertrag oder anere Dokument anescht vereinbert.</li>
<li><b>Reparatur vu zousätzleche Mängel:</b> De Client autoriséiert de Servicecenter, all zousätzlech Mängel ze reparéieren, déi während dem Service entdeckt ginn.</li>
<li><b>Net begläichene Verpflichtungen:</b> De Servicecenter kann d'Ausrüstung halen, bis all finanzell Verpflichtungen begläicht sinn. Wann Verpflichtungen dräi Méint onbezuelt bleiwen, ka de Servicecenter d'Ausrüstung vernichten, verkafen oder entsuergën.</li>
<li><b>Ausschlëss vun der Garantie:</b> Konfiguratioun, Installatioun, Software-Updates a Dateschutz sinn net vun Garantiereparaturen gedeckt.</li>
<li><b>Verantwortung fir Dateverloscht:</b> De Servicecenter iwwerhëlt keng Verantwortung fir Dateverloscht. Et muss eng Backup gemaach ginn virum Service.</li>
<li><b>Onbegrënnten Reklamatiounen:</b> Am Fall vun enger onbegrënnter Reklamatioun gëtt de Client fir Diagnose- a Versandkäschten berechent.</li>
<li><b>Diagnose ausserhalb vun der Garantie:</b> Diagnose vu Geräter ausserhalb vun der Garantie gëtt berechent, ausser de Client féiert d'Reparatur duerch.</li>
<li><b>Garantie deckt Schied net of:</b> Schied, déi net vun der Garantie gedeckt sinn, ginn net gratis reparéiert. Den Apparat gëtt an sengem Originalzoustand zréckginn, ausser de Client entscheed sech fir eng bezuelte Reparatur.</li>
<li><b>Zousätzlech Käschten fir widderholte Reklamatiounen:</b> Am Fall vun enger widderholter Reklamatioun a kengem Avertissement iwwer eng Reparatur ausserhalb vun der Garantie ginn zousätzlech administrativ a Transportkäschte vun 30 € (mat Mwst.) berechent.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[lb_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[lb_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[lb_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[lb_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '8' || $_userGroupID eq '12')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[lb_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[lb_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[lb_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[lb_f_errordescsh]}><{else}><{$_language[lb_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[lb_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie:</b> Gëllt bei Virweises vun engem zertifizéierte Garantieschäin oder der Originaifaktura.</li>
<li><b>Ännerunge vun Ausféierungszäiten:</b> All Meldung vum Servicecenter, sief et per Telefon, E-Mail, SMS oder agesch Bréif, ännert offiziell déi vereinbarte Ausféierungszäit.</li>
<li><b>Desaktivatioun vun Apple Find My, asw.:</b> De Client muss d'Find My-Fonction oder ähnlech virum Service desaktivéieren. Wann dat net geschitt, gëtt den Apparat ouni Verschaffen un de Client zréckginn, op seng Käschten.</li>
<li><b>Präisgestaltung:</b> De Client bestätegt d'Kenntnis vun der gëltege Präislëscht, déi ënnert dësem Link ze fannen ass: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Bäibehale vu gewiesselte Deeler:</b> Den Servicecenter behält all gewiesselt Deeler ouni Kompensatioun.</li>
<li><b>Net-Ofhale vum Apparat:</b> Wa de Client den Apparat net bannent 15 Deeg no Meldung vum Ofschloss vum Service ofhëlt, ginn Lagerungsgebiären no der Präislëscht berechent.</li>
<li><b>Besëtz vun engem net ofgehaalen Apparat:</b> Wa de Client den Apparat net bannent dräi Méint ofhëlt, geet den Besëtz un de Servicecenter.</li>
<li><b>Bezuelen vu Servicer:</b> Servicegebiären mussen virum Ofhale vum Apparat bezuelt ginn, ausser et gëtt an engem Vertrag oder anere Dokument anescht vereinbert.</li>
<li><b>Reparatur vu zousätzleche Mängel:</b> De Client autoriséiert de Servicecenter, all zousätzlech Mängel ze reparéieren, déi während dem Service entdeckt ginn.</li>
<li><b>Net begläichene Verpflichtungen:</b> De Servicecenter kann d'Ausrüstung halen, bis all finanzell Verpflichtungen begläicht sinn. Wann Verpflichtungen dräi Méint onbezuelt bleiwen, ka de Servicecenter d'Ausrüstung vernichten, verkafen oder entsuergën.</li>
<li><b>Ausschlëss vun der Garantie:</b> Konfiguratioun, Installatioun, Software-Updates a Dateschutz sinn net vun Garantiereparaturen gedeckt.</li>
<li><b>Verantwortung fir Dateverloscht:</b> De Servicecenter iwwerhëlt keng Verantwortung fir Dateverloscht. Et muss eng Backup gemaach ginn virum Service.</li>
<li><b>Onbegrënnten Reklamatiounen:</b> Am Fall vun enger onbegrënnter Reklamatioun gëtt de Client fir Diagnose- a Versandkäschten berechent.</li>
<li><b>Diagnose ausserhalb vun der Garantie:</b> Diagnose vu Geräter ausserhalb vun der Garantie gëtt berechent, ausser de Client féiert d'Reparatur duerch.</li>
<li><b>Garantie deckt Schied net of:</b> Schied, déi net vun der Garantie gedeckt sinn, ginn net gratis reparéiert. Den Apparat gëtt an sengem Originalzoustand zréckginn, ausser de Client entscheed sech fir eng bezuelte Reparatur.</li>
<li><b>Zousätzlech Käschten fir widderholte Reklamatiounen:</b> Am Fall vun enger widderholter Reklamatioun a kengem Avertissement iwwer eng Reparatur ausserhalb vun der Garantie ginn zousätzlech administrativ a Transportkäschte vun 30 € (mat Mwst.) berechent.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[lb_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[lb_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[lb_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[lb_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
<{/if}>


<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '9' || $_userGroupID eq '11')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[nl_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[nl_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[nl_f_errordescsh]}><{else}><{$_language[nl_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[nl_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie:</b> Geldig bij vertoon van een gecertificeerd garantiebewijs of de originele factuur.</li>
<li><b>Wijzigingen in uitvoeringstermijnen:</b> Elke kennisgeving van het servicecentrum, telefonisch, per e-mail, sms of aangetekende post, wijzigt officieel de overeengekomen uitvoeringstermijn.</li>
<li><b>Deactivering van Apple Zoek mijn, enz.:</b> De klant moet de Zoek mijn-functie of vergelijkbare functies uitschakelen vóór onderhoud. Als dit niet gebeurt, wordt het apparaat op kosten van de klant zonder verwerking geretourneerd.</li>
<li><b>Prijzen:</b> De klant bevestigt kennis te hebben van de geldende prijslijst, beschikbaar op: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Behoud van vervangen onderdelen:</b> Het servicecentrum behoudt alle vervangen onderdelen zonder vergoeding.</li>
<li><b>Niet-ophalen van het apparaat:</b> Als de klant het apparaat niet ophaalt binnen 15 dagen na kennisgeving van voltooiing van de service, worden opslagkosten in rekening gebracht volgens de prijslijst.</li>
<li><b>Eigendom van een niet-opgeëist apparaat:</b> Als de klant het apparaat niet binnen drie maanden ophaalt, gaat het eigendom over naar het servicecentrum.</li>
<li><b>Betaling voor diensten:</b> Servicekosten moeten worden betaald voordat het apparaat wordt opgehaald, tenzij anders overeengekomen in een contract of ander document.</li>
<li><b>Reparatie van extra defecten:</b> De klant machtigt het servicecentrum om extra defecten te repareren die tijdens het onderhoud worden ontdekt.</li>
<li><b>Onbetaalde verplichtingen:</b> Het servicecentrum kan de apparatuur behouden totdat alle financiële verplichtingen zijn voldaan. Als verplichtingen drie maanden onbetaald blijven, kan het servicecentrum de apparatuur vernietigen, verkopen of afvoeren.</li>
<li><b>Uitsluitingen van garantie:</b> Configuratie, installatie, software-updates en gegevensbehoud vallen niet onder garantiereparaties.</li>
<li><b>Aansprakelijkheid voor gegevensverlies:</b> Het servicecentrum aanvaardt geen verantwoordelijkheid voor gegevensverlies. Er moet een back-up worden gemaakt vóór onderhoud.</li>
<li><b>Ongerechtvaardigde klachten:</b> In het geval van een ongerechtvaardigde klacht worden de klant diagnose- en verzendkosten in rekening gebracht.</li>
<li><b>Diagnose buiten garantie:</b> Diagnose voor apparatuur buiten de garantie is tegen betaling, tenzij de klant doorgaat met de reparatie.</li>
<li><b>Garantie dekt geen schade:</b> Schade die niet onder de garantie valt, wordt niet gratis gerepareerd. Het apparaat wordt in de oorspronkelijke staat geretourneerd, tenzij de klant kiest voor een betaalde reparatie.</li>
<li><b>Extra kosten voor herhaalde klachten:</b> In het geval van een herhaalde klacht en onenigheid over een reparatie buiten de garantie, worden extra administratie- en transportkosten van € 30 (inclusief btw) in rekening gebracht.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[nl_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[nl_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[nl_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[nl_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '9' || $_userGroupID eq '11')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[nl_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[nl_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[nl_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[nl_f_errordescsh]}><{else}><{$_language[nl_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[nl_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie:</b> Geldig bij vertoon van een gecertificeerd garantiebewijs of de originele factuur.</li>
<li><b>Wijzigingen in uitvoeringstermijnen:</b> Elke kennisgeving van het servicecentrum, telefonisch, per e-mail, sms of aangetekende post, wijzigt officieel de overeengekomen uitvoeringstermijn.</li>
<li><b>Deactivering van Apple Zoek mijn, enz.:</b> De klant moet de Zoek mijn-functie of vergelijkbare functies uitschakelen vóór onderhoud. Als dit niet gebeurt, wordt het apparaat op kosten van de klant zonder verwerking geretourneerd.</li>
<li><b>Prijzen:</b> De klant bevestigt kennis te hebben van de geldende prijslijst, beschikbaar op: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Behoud van vervangen onderdelen:</b> Het servicecentrum behoudt alle vervangen onderdelen zonder vergoeding.</li>
<li><b>Niet-ophalen van het apparaat:</b> Als de klant het apparaat niet ophaalt binnen 15 dagen na kennisgeving van voltooiing van de service, worden opslagkosten in rekening gebracht volgens de prijslijst.</li>
<li><b>Eigendom van een niet-opgeëist apparaat:</b> Als de klant het apparaat niet binnen drie maanden ophaalt, gaat het eigendom over naar het servicecentrum.</li>
<li><b>Betaling voor diensten:</b> Servicekosten moeten worden betaald voordat het apparaat wordt opgehaald, tenzij anders overeengekomen in een contract of ander document.</li>
<li><b>Reparatie van extra defecten:</b> De klant machtigt het servicecentrum om extra defecten te repareren die tijdens het onderhoud worden ontdekt.</li>
<li><b>Onbetaalde verplichtingen:</b> Het servicecentrum kan de apparatuur behouden totdat alle financiële verplichtingen zijn voldaan. Als verplichtingen drie maanden onbetaald blijven, kan het servicecentrum de apparatuur vernietigen, verkopen of afvoeren.</li>
<li><b>Uitsluitingen van garantie:</b> Configuratie, installatie, software-updates en gegevensbehoud vallen niet onder garantiereparaties.</li>
<li><b>Aansprakelijkheid voor gegevensverlies:</b> Het servicecentrum aanvaardt geen verantwoordelijkheid voor gegevensverlies. Er moet een back-up worden gemaakt vóór onderhoud.</li>
<li><b>Ongerechtvaardigde klachten:</b> In het geval van een ongerechtvaardigde klacht worden de klant diagnose- en verzendkosten in rekening gebracht.</li>
<li><b>Diagnose buiten garantie:</b> Diagnose voor apparatuur buiten de garantie is tegen betaling, tenzij de klant doorgaat met de reparatie.</li>
<li><b>Garantie dekt geen schade:</b> Schade die niet onder de garantie valt, wordt niet gratis gerepareerd. Het apparaat wordt in de oorspronkelijke staat geretourneerd, tenzij de klant kiest voor een betaalde reparatie.</li>
<li><b>Extra kosten voor herhaalde klachten:</b> In het geval van een herhaalde klacht en onenigheid over een reparatie buiten de garantie, worden extra administratie- en transportkosten van € 30 (inclusief btw) in rekening gebracht.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[nl_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[nl_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[nl_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[nl_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
<{/if}>

<!-- Successful Repair Report Template -->
<{if $_ticketStatusTitle eq 'Popravljen | Zaključen' || $_ticketStatusTitle eq 'Vrnjen | Dobavitelju' || $_ticketStatusTitle eq 'Zamenjan | Zaključen' || $_ticketStatusTitle eq 'Repariert | Abgeschlossen' || $_ticketStatusTitle eq 'Repaired | Completed'}>
<div class="page" style="break-before: page;min-height: 297mm; padding: 10px; margin: 0 auto; background-color: white; position: relative; color: #333;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #2857a8;">
        <img src="https://www.kron.si/servis/__swift/themes/__cp/images/kron.png" alt="Logo" style="height: 60px;">
        <div style="text-align: center; flex-grow: 1; color: #2857a8; font-size: 24px; font-weight: 700; text-transform: uppercase;">
            <span><{$_language[report_title]}></span>
        </div>
        <div>
            <strong><{$_language[ticket_number]}>:</strong> <{$_ticketID}>
        </div>
    </div>
    
    <div style="background-color: #4CAF50; color: white; text-align: center; padding: 10px; margin-bottom: 20px; border-radius: 5px; font-weight: 700; font-size: 18px; text-transform: uppercase; letter-spacing: 1px;">
        <{$_language[repair_success]}>
    </div>
    
    <div style="display: flex;flex-direction: column;width: 100%;margin: 0 !important;padding: 0 !important;">
        <h2 style="padding-left: 10px;color: #2857a8;padding-bottom: 5px;border-bottom: 1px solid #ddd;padding-top: 0px !important;margin: 0px;margin: 10px 0px;"><{$_language[device_info_heading]}></h2>
                    <!-- IMEI / Serial Number with special emphasis -->
            <div style="display: flex;margin: 0px 10px;padding: 10px;background-color: #f5f5f5;border-radius: 5px;border-left: 5px solid #2857a8;gap: 10px;justify-content: flex-start;align-items: center;">
                <div style="font-weight: 700; color: #2857a8;"><{$_language[serial_imei_label]}></div>
                <div style="display: flex; align-items: center;">
                    <span style="font-size: 16px; font-weight: 600; margin-right: 15px;"><{$_ticketSubject}></span>
                </div>
            </div>
        <!-- Device Info and Custom Fields -->
        <div style="display: flex;flex-direction: column;padding: 0 !important;margin: 0 !important;">
            <!-- Display all custom fields (already working in your existing template) -->
            <{if $_customFields ne '' }>
                <style>
                    .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                        display: none !important;
                    }
                </style>
                <{$_customFields}>
            <{/if}>
        </div>
    </div>
    
    <div style="margin: 0px 10px; margin-bottom: 20px;">
        <h2 style="color: #2857a8; padding-bottom: 5px; border-bottom: 1px solid #ddd; margin-bottom: 15px;"><{$_language[test_results_heading]}></h2>
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[battery_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[charger_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[keyboard_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[trackpad_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[sleep_mode_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[dead_pixel_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[sound_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[wifi_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[camera_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[mic_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[ports_test]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
            <div style="display: flex; align-items: center; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #4CAF50;">
                <span style="flex-grow: 1; font-weight: 600;"><{$_language[general_functionality]}></span>
                <span style="font-weight: 700; color: #4CAF50;">✓ <{$_language[test_passed]}></span>
            </div>
        </div>
    </div>
    
    <div style="margin-top: 60px; display: flex; justify-content: space-between; align-items: center; padding-top: 20px; border-top: 1px solid #ddd; font-size: 12px; color: #666;">
        <div>
            <div>Kron IT, d.o.o.</div>
            <div>Zagrebška cesta 83a, 2000 Maribor, Slovenia</div>
            <div>Tel: +386 30 685 808 | Email: vprasanja@kron.si</div>
        </div>
        <img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=80x80" style="width: 80px; height: 80px;">
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '10' || $_userGroupID eq '13')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[hu_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[hu_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[hu_f_errordescsh]}><{else}><{$_language[hu_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[hu_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie :</b> Valable sur présentation d'un certificat de garantie certifié ou de la facture originale.</li>
<li><b>Modifications des délais d'exécution :</b> Toute notification du centre de service, qu'elle soit donnée par téléphone, e-mail, SMS ou courrier recommandé, modifie officiellement le délai d'exécution convenu.</li>
<li><b>Désactivation d'Apple Localiser, etc. :</b> Le client doit désactiver la fonction Localiser ou similaire avant l'entretien. Si cela n'est pas fait, l'appareil sera retourné sans traitement aux frais du client.</li>
<li><b>Tarification :</b> Le client confirme avoir connaissance de la liste des prix applicable, disponible à l'adresse : <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservation des pièces remplacées :</b> Le centre de service conserve toutes les pièces remplacées sans compensation.</li>
<li><b>Non-récupération de l'appareil :</b> Si le client ne récupère pas l'appareil dans les 15 jours suivant la notification de la fin du service, des frais de stockage seront facturés selon la liste des prix.</li>
<li><b>Propriété d'un appareil non réclamé :</b> Si le client ne récupère pas l'appareil dans les trois mois, la propriété est transférée au centre de service.</li>
<li><b>Paiement des services :</b> Les coûts de service doivent être réglés avant de récupérer l'appareil, sauf accord contraire dans un contrat ou autre document.</li>
<li><b>Réparation de défauts supplémentaires :</b> Le client autorise le centre de service à réparer tout défaut supplémentaire découvert pendant l'entretien.</li>
<li><b>Obligations non réglées :</b> Le centre de service peut conserver l'équipement jusqu'à ce que toutes les obligations financières soient réglées. Si les obligations restent impayées pendant trois mois, le centre de service peut détruire, vendre ou éliminer l'équipement.</li>
<li><b>Exclusions de garantie :</b> La configuration, l'installation, les mises à jour logicielles et la préservation des données ne sont pas couvertes par les réparations sous garantie.</li>
<li><b>Responsabilité pour perte de données :</b> Le centre de service n'assume aucune responsabilité pour la perte de données. Une sauvegarde doit être créée avant l'entretien.</li>
<li><b>Réclamations injustifiées :</b> En cas de réclamation injustifiée, le client sera facturé pour les frais de diagnostic et d'expédition.</li>
<li><b>Diagnostic hors garantie :</b> Le diagnostic pour les équipements hors garantie est payant, sauf si le client procède à la réparation.</li>
<li><b>La garantie ne couvre pas les dommages :</b> Les dommages non couverts par la garantie ne seront pas réparés gratuitement. L'appareil sera retourné dans son état d'origine à moins que le client n'opte pour une réparation payante.</li>
<li><b>Coûts supplémentaires pour les réclamations répétées :</b> En cas de réclamation répétée et de désaccord avec une réparation hors garantie, des frais administratifs et de transport supplémentaires de 30 € (TVA incluse) seront facturés.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[hu_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[hu_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[hu_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[hu_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '10' || $_userGroupID eq '13')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[hu_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[hu_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[hu_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[hu_f_errordescsh]}><{else}><{$_language[hu_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[hu_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie :</b> Valable sur présentation d'un certificat de garantie certifié ou de la facture originale.</li>
<li><b>Modifications des délais d'exécution :</b> Toute notification du centre de service, qu'elle soit donnée par téléphone, e-mail, SMS ou courrier recommandé, modifie officiellement le délai d'exécution convenu.</li>
<li><b>Désactivation d'Apple Localiser, etc. :</b> Le client doit désactiver la fonction Localiser ou similaire avant l'entretien. Si cela n'est pas fait, l'appareil sera retourné sans traitement aux frais du client.</li>
<li><b>Tarification :</b> Le client confirme avoir connaissance de la liste des prix applicable, disponible à l'adresse : <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservation des pièces remplacées :</b> Le centre de service conserve toutes les pièces remplacées sans compensation.</li>
<li><b>Non-récupération de l'appareil :</b> Si le client ne récupère pas l'appareil dans les 15 jours suivant la notification de la fin du service, des frais de stockage seront facturés selon la liste des prix.</li>
<li><b>Propriété d'un appareil non réclamé :</b> Si le client ne récupère pas l'appareil dans les trois mois, la propriété est transférée au centre de service.</li>
<li><b>Paiement des services :</b> Les coûts de service doivent être réglés avant de récupérer l'appareil, sauf accord contraire dans un contrat ou autre document.</li>
<li><b>Réparation de défauts supplémentaires :</b> Le client autorise le centre de service à réparer tout défaut supplémentaire découvert pendant l'entretien.</li>
<li><b>Obligations non réglées :</b> Le centre de service peut conserver l'équipement jusqu'à ce que toutes les obligations financières soient réglées. Si les obligations restent impayées pendant trois mois, le centre de service peut détruire, vendre ou éliminer l'équipement.</li>
<li><b>Exclusions de garantie :</b> La configuration, l'installation, les mises à jour logicielles et la préservation des données ne sont pas couvertes par les réparations sous garantie.</li>
<li><b>Responsabilité pour perte de données :</b> Le centre de service n'assume aucune responsabilité pour la perte de données. Une sauvegarde doit être créée avant l'entretien.</li>
<li><b>Réclamations injustifiées :</b> En cas de réclamation injustifiée, le client sera facturé pour les frais de diagnostic et d'expédition.</li>
<li><b>Diagnostic hors garantie :</b> Le diagnostic pour les équipements hors garantie est payant, sauf si le client procède à la réparation.</li>
<li><b>La garantie ne couvre pas les dommages :</b> Les dommages non couverts par la garantie ne seront pas réparés gratuitement. L'appareil sera retourné dans son état d'origine à moins que le client n'opte pour une réparation payante.</li>
<li><b>Coûts supplémentaires pour les réclamations répétées :</b> En cas de réclamation répétée et de désaccord avec une réparation hors garantie, des frais administratifs et de transport supplémentaires de 30 € (TVA incluse) seront facturés.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[hu_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[hu_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[hu_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[hu_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '15' || $_userGroupID eq '16')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[it_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[it_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[it_f_errordescsh]}><{else}><{$_language[it_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[it_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garanzia:</b> Valida su presentazione di un certificato di garanzia certificato o della fattura originale.</li>
<li><b>Modifiche alle scadenze di esecuzione:</b> Qualsiasi notifica dal centro di assistenza, sia telefonica, via email, SMS o posta raccomandata, modifica ufficialmente la scadenza di esecuzione concordata.</li>
<li><b>Disattivazione di Apple Dov'è, ecc.:</b> Il cliente deve disattivare la funzione Dov'è o simili prima dell'assistenza. In caso contrario, il dispositivo sarà restituito senza elaborazione a spese del cliente.</li>
<li><b>Prezzi:</b> Il cliente conferma di essere a conoscenza del listino prezzi applicabile, disponibile all'indirizzo: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservazione delle parti sostituite:</b> Il centro di assistenza conserva tutte le parti sostituite senza compenso.</li>
<li><b>Mancato ritiro del dispositivo:</b> Se il cliente non ritira il dispositivo entro 15 giorni dalla notifica del completamento del servizio, saranno addebitate spese di deposito secondo il listino prezzi.</li>
<li><b>Proprietà di un dispositivo non reclamato:</b> Se il cliente non ritira il dispositivo entro tre mesi, la proprietà passa al centro di assistenza.</li>
<li><b>Pagamento dei servizi:</b> I costi del servizio devono essere saldati prima del ritiro del dispositivo, salvo diversamente concordato in un contratto o altro documento.</li>
<li><b>Riparazione di difetti aggiuntivi:</b> Il cliente autorizza il centro di assistenza a riparare eventuali difetti aggiuntivi scoperti durante l'assistenza.</li>
<li><b>Obblighi non saldati:</b> Il centro di assistenza può trattenere l'apparecchiatura fino a quando tutti gli obblighi finanziari sono saldati. Se gli obblighi rimangono non pagati per tre mesi, il centro di assistenza può distruggere, vendere o smaltire l'apparecchiatura.</li>
<li><b>Esclusioni dalla garanzia:</b> Configurazione, installazione, aggiornamenti software e conservazione dei dati non sono coperti dalle riparazioni in garanzia.</li>
<li><b>Responsabilità per la perdita di dati:</b> Il centro di assistenza non si assume alcuna responsabilità per la perdita di dati. È necessario creare un backup prima dell'assistenza.</li>
<li><b>Reclami ingiustificati:</b> In caso di reclamo ingiustificato, al cliente saranno addebitati i costi di diagnostica e spedizione.</li>
<li><b>Diagnostica fuori garanzia:</b> La diagnostica per apparecchiature fuori garanzia è a pagamento, a meno che il cliente non proceda con la riparazione.</li>
<li><b>La garanzia non copre i danni:</b> I danni non coperti dalla garanzia non saranno riparati gratuitamente. Il dispositivo sarà restituito nelle sue condizioni originali a meno che il cliente non opti per una riparazione a pagamento.</li>
<li><b>Costi aggiuntivi per reclami ripetuti:</b> In caso di reclamo ripetuto e disaccordo con una riparazione fuori garanzia, saranno addebitati costi amministrativi e di trasporto aggiuntivi di € 30 (IVA inclusa).</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[it_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[it_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[it_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[it_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>

<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '15' || $_userGroupID eq '16')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[it_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[it_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[it_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[it_f_errordescsh]}><{else}><{$_language[it_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[it_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garanzia:</b> Valida su presentazione di un certificato di garanzia certificato o della fattura originale.</li>
<li><b>Modifiche alle scadenze di esecuzione:</b> Qualsiasi notifica dal centro di assistenza, sia telefonica, via email, SMS o posta raccomandata, modifica ufficialmente la scadenza di esecuzione concordata.</li>
<li><b>Disattivazione di Apple Dov'è, ecc.:</b> Il cliente deve disattivare la funzione Dov'è o simili prima dell'assistenza. In caso contrario, il dispositivo sarà restituito senza elaborazione a spese del cliente.</li>
<li><b>Prezzi:</b> Il cliente conferma di essere a conoscenza del listino prezzi applicabile, disponibile all'indirizzo: <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservazione delle parti sostituite:</b> Il centro di assistenza conserva tutte le parti sostituite senza compenso.</li>
<li><b>Mancato ritiro del dispositivo:</b> Se il cliente non ritira il dispositivo entro 15 giorni dalla notifica del completamento del servizio, saranno addebitate spese di deposito secondo il listino prezzi.</li>
<li><b>Proprietà di un dispositivo non reclamato:</b> Se il cliente non ritira il dispositivo entro tre mesi, la proprietà passa al centro di assistenza.</li>
<li><b>Pagamento dei servizi:</b> I costi del servizio devono essere saldati prima del ritiro del dispositivo, salvo diversamente concordato in un contratto o altro documento.</li>
<li><b>Riparazione di difetti aggiuntivi:</b> Il cliente autorizza il centro di assistenza a riparare eventuali difetti aggiuntivi scoperti durante l'assistenza.</li>
<li><b>Obblighi non saldati:</b> Il centro di assistenza può trattenere l'apparecchiatura fino a quando tutti gli obblighi finanziari sono saldati. Se gli obblighi rimangono non pagati per tre mesi, il centro di assistenza può distruggere, vendere o smaltire l'apparecchiatura.</li>
<li><b>Esclusioni dalla garanzia:</b> Configurazione, installazione, aggiornamenti software e conservazione dei dati non sono coperti dalle riparazioni in garanzia.</li>
<li><b>Responsabilità per la perdita di dati:</b> Il centro di assistenza non si assume alcuna responsabilità per la perdita di dati. È necessario creare un backup prima dell'assistenza.</li>
<li><b>Reclami ingiustificati:</b> In caso di reclamo ingiustificato, al cliente saranno addebitati i costi di diagnostica e spedizione.</li>
<li><b>Diagnostica fuori garanzia:</b> La diagnostica per apparecchiature fuori garanzia è a pagamento, a meno che il cliente non proceda con la riparazione.</li>
<li><b>La garanzia non copre i danni:</b> I danni non coperti dalla garanzia non saranno riparati gratuitamente. Il dispositivo sarà restituito nelle sue condizioni originali a meno che il cliente non opti per una riparazione a pagamento.</li>
<li><b>Costi aggiuntivi per reclami ripetuti:</b> In caso di reclamo ripetuto e disaccordo con una riparazione fuori garanzia, saranno addebitati costi amministrativi e di trasporto aggiuntivi di € 30 (IVA inclusa).</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[it_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[it_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[it_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[it_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<{/if}>

<{if $_ticketStatusTitle ne 'Repaired / Delivered to courier' && ($_userGroupID eq '7' || $_userGroupID eq '14')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[fr_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<{$_ticketDepartment}>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[fr_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[fr_f_errordescsh]}><{else}><{$_language[fr_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[fr_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie :</b> Valable sur présentation d'un certificat de garantie certifié ou de la facture originale.</li>
<li><b>Modifications des délais d'exécution :</b> Toute notification du centre de service, qu'elle soit donnée par téléphone, e-mail, SMS ou courrier recommandé, modifie officiellement le délai d'exécution convenu.</li>
<li><b>Désactivation d'Apple Localiser, etc. :</b> Le client doit désactiver la fonction Localiser ou similaire avant l'entretien. Si cela n'est pas fait, l'appareil sera retourné sans traitement aux frais du client.</li>
<li><b>Tarification :</b> Le client confirme avoir connaissance de la liste des prix applicable, disponible à l'adresse : <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservation des pièces remplacées :</b> Le centre de service conserve toutes les pièces remplacées sans compensation.</li>
<li><b>Non-récupération de l'appareil :</b> Si le client ne récupère pas l'appareil dans les 15 jours suivant la notification de la fin du service, des frais de stockage seront facturés selon la liste des prix.</li>
<li><b>Propriété d'un appareil non réclamé :</b> Si le client ne récupère pas l'appareil dans les trois mois, la propriété est transférée au centre de service.</li>
<li><b>Paiement des services :</b> Les coûts de service doivent être réglés avant de récupérer l'appareil, sauf accord contraire dans un contrat ou autre document.</li>
<li><b>Réparation de défauts supplémentaires :</b> Le client autorise le centre de service à réparer tout défaut supplémentaire découvert pendant l'entretien.</li>
<li><b>Obligations non réglées :</b> Le centre de service peut conserver l'équipement jusqu'à ce que toutes les obligations financières soient réglées. Si les obligations restent impayées pendant trois mois, le centre de service peut détruire, vendre ou éliminer l'équipement.</li>
<li><b>Exclusions de garantie :</b> La configuration, l'installation, les mises à jour logicielles et la préservation des données ne sont pas couvertes par les réparations sous garantie.</li>
<li><b>Responsabilité pour perte de données :</b> Le centre de service n'assume aucune responsabilité pour la perte de données. Une sauvegarde doit être créée avant l'entretien.</li>
<li><b>Réclamations injustifiées :</b> En cas de réclamation injustifiée, le client sera facturé pour les frais de diagnostic et d'expédition.</li>
<li><b>Diagnostic hors garantie :</b> Le diagnostic pour les équipements hors garantie est payant, sauf si le client procède à la réparation.</li>
<li><b>La garantie ne couvre pas les dommages :</b> Les dommages non couverts par la garantie ne seront pas réparés gratuitement. L'appareil sera retourné dans son état d'origine à moins que le client n'opte pour une réparation payante.</li>
<li><b>Coûts supplémentaires pour les réclamations répétées :</b> En cas de réclamation répétée et de désaccord avec une réparation hors garantie, des frais administratifs et de transport supplémentaires de 30 € (TVA incluse) seront facturés.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[fr_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[fr_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[fr_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[fr_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
    <br>
<div style="width: 13.5cm; border-top: 2px dashed #000; margin-right: 10px; border-right: 2px dashed #000;">
    <div style="display: contents; font-size: 1.2rem !important; text-transform: uppercase; margin-top: 15px; color: #111; background-color: #fff; border: 1px solid #bbb; margin-left: 5px;">
        <table style="border-collapse: collapse; text-transform: none !important; font-size: 1.1rem !important; width: 100%;" cellspacing="2" cellpadding="2">
<tr style="text-align: center; vertical-align: middle;">
    <td style="display: table-cell; border-bottom: 1px solid #111; border-right: 1px solid #111; color: #111;padding: 5px 3px; justify-content: center; vertical-align: middle; align-content: center; text-align: center; align-items: center;">
        <b>
            <span style="text-transform: uppercase;">
                <{$_language[en_f_ticketidsh]}>
        </span>   
        </b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.1&ts=11&th=11" style="padding: 0 !important; margin-top: -3px; background: transparent;">  
</td>
    <td style="display: flex;flex-direction: row;border-bottom: 1px solid #111;padding: 5px 3px;justify-content: center;color: #111;vertical-align: middle;align-items: center;">
        <b>
            <span style="text-transform: uppercase; font-weight: 600;">
                <{$_language[en_f_subjectsh]}>
</b>
        <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.75&sy=0.1" style="padding: 0 !important; margin-top: -3px; background: transparent;">
</span>
    </td>
</tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_dateopen]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b><span style="text-transform: uppercase; font-weight: 400;"><{$_ticketDate}></b></span></td>
            </tr>
            <tr>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="left"><b><span style="text-transform: uppercase;"><{$_language[en_f_customersh]}></b></span></td>
                <td style="border-bottom: 1px solid #111; padding: 5px; width: 50%; color: #111;" align="right"><b style="text-transform: uppercase;">
                <i class="fa fa-user" aria-hidden="true"></i> <{$_fullName}>
            </b><br>
            <span><i class="fa fa-phone" aria-hidden="true"></i> <{$_userPhoneNumber}></span>
        </td>
            </tr>
<tr style="width: 100%; min-height: 100px;">
<td style="width: 100%; padding-bottom: 50px; padding-left: 3px; padding-right: 3px;"><span style="text-transform: uppercase;"><b><{$_language[en_f_ordernotes]}></b></span></td>
</tr>
        </table>
    </div>
</div>
<{/if}>
<{if $_ticketStatusTitle eq 'Repaired / Delivered to courier' && ($_userGroupID eq '7' || $_userGroupID eq '14')}>
<div style="background-color: #fff; width: 1080px; font-size: 1.2rem !important;">
<div style="display: table;">
<div style="display: table-row;">
<table style="width: 100%;" cellspacing="0" cellpadding="0" font-size: 1.2rem !important;">        
    <tr>
        <td align="left" width="50%" style="padding-bottom: 5px; color: #111; margin-left: 15px; margin-bottom: 5px;"><b><{$_language[fr_f_dateopen]}></b> <{$_ticketDate}></td>
    </tr>
</table>
<{$_ticketDepartment}>
<img align="center" width="100%" src="https://www.kron.si/servis/glavasqt.png" />   
<br>
</div>
</div>
<br>
<div style="font-size: 1.2rem !important; background-color: #fff; margin-left: 10px; margin-right: 10px;">
<table style="width: 100%; margin-bottom: 15px; font-size: 1.2rem !important;" cellspacing="1" cellpadding="3">
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">&nbsp;</td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; color: #111; padding: 8px 10px; display: inline-block; text-transform: uppercase; background-color: #f1f1f1; font-size: 1.55rem;">
            <b><{$_language[fr_f_ticketid]}></b><span style="color: #000;  font-weight: 300;"> <{$_ticketID}> </span>
        </div>
    </td> 
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_customersh]}></b> <span style="text-transform: uppercase;"><{$_fullName}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_subject]}></b> <span style="text-transform: uppercase;"><{$_ticketSubject}></span></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_address]}></b> <span style="text-transform: uppercase;"><{$_naslovStranke}>, <{$_postnaStevilka}></span></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_dateopen]}></b> <{$_ticketDate}></td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_phone]}></b> <{$_userPhoneNumber}></td>
    <td align="right" width="50%" style="padding-bottom: 5px; color: #111;"><b><{$_language[fr_f_dateclosed]}></b> <{$_ticketUpdated}></td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td align="left" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
    <td align="right" width="50%" style="padding-bottom: 5px;">
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketID}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
        &nbsp;&nbsp;
        <div style="border: 1px solid #bbb; border-radius: 10px; display: inline-block; text-transform: uppercase; padding-bottom: 10px;">
            <img src="https://barcodes.pro/get/generator?f=svg&s=code128&d=<{$_ticketSubject}>&sf=0.7&sy=0.15&ts=11&th=11">
        </div>
    </td>
</tr>
</table>
</div>
<div style="font-size: 1.2rem !important; background-color: #fff; color: #111; border-color: #bbb;">
     <{if $_customFields ne '' }>
        <style>
            .customfieldcol2 img, .customfieldcol1 img, .customfieldcol1_pink img, .customfieldcol2_pink img .customfieldcol1_pink img, .customfieldcol2_pink img, .customfieldstaticcontent img {
                display: none !important;
            }
        </style>
        <{$_customFields}>
    <{/if}>
<hr style="border: 0; border-top: 1px solid #bbb;">
</div>
<{assign var="counter" value=0}>
<{foreach key=key item=_item from=$_ticketPost}>
    <div class="customfieldstaticcontainer3">
        <table style="width: 100%; font-size: 1.2rem !important; border-collapse: collapse; text-transform: none !important;">
            <tr>
                <td>
                    <span style="text-transform: none !important;">
                        <div class="customfieldstatictitlepost">
                            <b><{if $counter == 0}><{$_language[fr_f_errordescsh]}><{else}><{$_language[fr_f_fixdesc]}><{/if}></b>
                        </div>
                        <div class="customfieldstaticcontentpost" style="text-transform: none !important;">
                            <{$_item[contents]}>
                        </div>
                    </span>
                </td>
            </tr>
        </table>
    </div>
    <{assign var="counter" value=$counter+1}>
<{/foreach}>
<div class="customfieldstaticcontainer3" style="margin-top: 10px;">
<div class="customfieldstatictitle" style="font-size: 1.2rem !important; font-weight: 600;">
    <{$_language[fr_f_termsagree]}>
</div>
<div class="customfieldstaticcontentterms" style="margin-left: -10px;">
<table cellspacing="0" cellpadding="0" style="border-collapse: collapse; text-transform: none !important; font-size: 1rem !important; width: 100%;">
<tr>
    <td>
<ol>
<li><b>Garantie :</b> Valable sur présentation d'un certificat de garantie certifié ou de la facture originale.</li>
<li><b>Modifications des délais d'exécution :</b> Toute notification du centre de service, qu'elle soit donnée par téléphone, e-mail, SMS ou courrier recommandé, modifie officiellement le délai d'exécution convenu.</li>
<li><b>Désactivation d'Apple Localiser, etc. :</b> Le client doit désactiver la fonction Localiser ou similaire avant l'entretien. Si cela n'est pas fait, l'appareil sera retourné sans traitement aux frais du client.</li>
<li><b>Tarification :</b> Le client confirme avoir connaissance de la liste des prix applicable, disponible à l'adresse : <a href="https://www.kron.si/cenik.pdf">https://www.kron.si/cenik.pdf</a>.</li>
<li><b>Conservation des pièces remplacées :</b> Le centre de service conserve toutes les pièces remplacées sans compensation.</li>
<li><b>Non-récupération de l'appareil :</b> Si le client ne récupère pas l'appareil dans les 15 jours suivant la notification de la fin du service, des frais de stockage seront facturés selon la liste des prix.</li>
<li><b>Propriété d'un appareil non réclamé :</b> Si le client ne récupère pas l'appareil dans les trois mois, la propriété est transférée au centre de service.</li>
<li><b>Paiement des services :</b> Les coûts de service doivent être réglés avant de récupérer l'appareil, sauf accord contraire dans un contrat ou autre document.</li>
<li><b>Réparation de défauts supplémentaires :</b> Le client autorise le centre de service à réparer tout défaut supplémentaire découvert pendant l'entretien.</li>
<li><b>Obligations non réglées :</b> Le centre de service peut conserver l'équipement jusqu'à ce que toutes les obligations financières soient réglées. Si les obligations restent impayées pendant trois mois, le centre de service peut détruire, vendre ou éliminer l'équipement.</li>
<li><b>Exclusions de garantie :</b> La configuration, l'installation, les mises à jour logicielles et la préservation des données ne sont pas couvertes par les réparations sous garantie.</li>
<li><b>Responsabilité pour perte de données :</b> Le centre de service n'assume aucune responsabilité pour la perte de données. Une sauvegarde doit être créée avant l'entretien.</li>
<li><b>Réclamations injustifiées :</b> En cas de réclamation injustifiée, le client sera facturé pour les frais de diagnostic et d'expédition.</li>
<li><b>Diagnostic hors garantie :</b> Le diagnostic pour les équipements hors garantie est payant, sauf si le client procède à la réparation.</li>
<li><b>La garantie ne couvre pas les dommages :</b> Les dommages non couverts par la garantie ne seront pas réparés gratuitement. L'appareil sera retourné dans son état d'origine à moins que le client n'opte pour une réparation payante.</li>
<li><b>Coûts supplémentaires pour les réclamations répétées :</b> En cas de réclamation répétée et de désaccord avec une réparation hors garantie, des frais administratifs et de transport supplémentaires de 30 € (TVA incluse) seront facturés.</li>
</ol>
</td>
</tr>
</table>
</div>
</div>
<br>
<div align="center" style="font-size: 1.1rem;"><{$_language[fr_f_terms2]}></div>
<br><br>
<div style="font-size: 1.2rem !important;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 20px; margin-top: 20px;">
        <tr>
            <td align="center" valign="top" width="35%"><b><{$_language[fr_f_signstamp]}></b><br><img align="center" width="140px" src="https://www.kron.si/servis/podp_stemp.png" /></td>
            <td align="center" valign="top" width="30%"><b><{$_language[fr_f_statuscheck]}></b><br><br><img src="https://api.qrserver.com/v1/create-qr-code/?data=https://www.kron.si/status/index.html&amp;size=90x90"></td>
            <td align="center" valign="top" width="35%"><b><{$_language[fr_f_signcust]}></b><br><span style="text-transform: uppercase;"><{$_fullName}><br><br><{$_podpis}></span></td>
        </tr>
    </table>
<{/if}>
</body>
</html>