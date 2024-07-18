{: /* Mickael - Biochimie - le 25/03/2024 - CHU NIMES -  MISPL Etiquette Neurogénétique ALL MAT (modification dimension  des étiquettes (-80°c)) */
   /* Mickael - Oncogénétique Somatique - Le 02/05/2024 - CHU NIMES - AJOUT Activité Oncosomatique TNA (Uniformisation des étiquettes */

STRING CB, sNB1, sSero, sId, sMat, sSQBtq, sBtq, sPrel, sDiag1, sDemo,sLN, sFN, sDDN, sMM, sMatS, sLAB, sH, sSD, sROSA, sPlan, sStorage, sTypo ;
STRING sDelai, sRp, sPl;                           
PERSON cPERS;           
ORDER oORD;
MATERIAL cMat;
APPROACH cApproach;

cMat   := .Material;
sMM  := cMat.Mnemonic;
sMatS  := cPad(cMat.SamplingCode,15," ");
oORD	  := .LastRequest(?).Order;
cPERS	  := .Object.Person();
sId	  := IfKnownString(Substr(.InternalId,1,10));
sFN     := ToUpper(IfKnownString(substr(cPERS.FirstName,1,15)));
sLN     := ToUpper(IfKnownString(cPERS.LastName));

/*IF Len(cPers.SpouseLastName) > 2 AND Substr(EnumeratedToString("SEX",cPERS.Sex),1,1) = "F" THEN 
    sLN     := ToUpper(IfKnownString(cPERS.LastName) +"(" +IfKnownString(cPers.SpouseLastName) + ")");
ENDIF;*/

sDDN    := IfKnownString(" Ne(e):" + DateToString(cPERS.BirthDate,"%d/%m/%Y") + " [" + Substr(EnumeratedToString("SEX",cPERS.Sex),1,1) + "]");

sPrel   := "Preleve le " + DateTimeToString(.SamplingTime,"%d/%m/%y");
sRp     := DateTimeToString(oORD.CreationTime,"%Y%m%d%H%M");
sPL     := DateTimeToString(oORD.LowestObjectTime,"%Y%m%d%H%M");
sDelai  := Replace(FractionalToString(
          (DateAndTimeToDateTime(StringToDate(SubStr(sRp,7,2) + "/" + SubStr(sRp,5,2) + "/" + SubStr(sRp,1,4)), StringToTime(SubStr(sRp,9,2) + ":" + SubStr(sRp,11,2) + ":"+ SubStr(sRp,13,2))) - 		 					     DateAndTimeToDateTime(StringToDate(SubStr(sPL,7,2) + "/" + SubStr(sPL,5,2) + "/" + SubStr(sPL,1,4)), StringToTime(SubStr(sPL,9,2) + ":" + SubStr(sPL,11,2) + ":"+ SubStr(sPL,13,2)))) *24,"%2.0f"),".","h")+"h";
	
sLAB    := GetSiteAttribute("Material",.Material.Id,"LABEL_NEURO");
sTypo   := GetSiteAttribute("Material",.Material.Id,"TYPE_NEURO");

sROSA   := IfKnownString("Inclusion " + ToUpper(Replace(oORD.Result("BB_INCLUSION-ROSA", ?, ?).Attribute("Value"),":","")));

sStorage := IfKnownString(Replace(Entry(1,.StorageLocation,":"), Substr(sSero,9,10),""));
sStorage := IfKnownString(Replace(Replace(Entry(1,sStorage,"/") + "/" + Replace(Entry(2,sStorage,"/"),"00",""),"-00","-"),"-0","-")); 

IF sStorage = "" AND sTypo <> "DOSSIER" AND sTypo <> "PROJET" THEN sStorage := "Pas de biotheq"; ENDIF;

cApproach := .SpecimenOutput().Action.ApproachActivity().Approach ;
sPlan := IfKnownString(Replace(Replace(Replace(Replace(Replace(Replace(Substr(cApproach.ApproachPlan.Mnemonic,7,-1),"_"," "),"-"," "),"LEUCODYSTROPHIE","CSF1R"),"OBESITE MORBIDE","MC4R"),"PHAR_ITK","ITK"),"SLA ALL NGS","SLA"));
sPlan := IfKnownString(Replace(sPlan,"PHAR OUT NGS","PHARMA"));

/*____________________________________________________________________________________    ETIQUETTE DECLARATION VARIABLES  __________________________________________________________________________________*/        
 
   CB := CB + "^XA^LL-10^LH0,20^^LT0^MD35"		                       + chr(10);                 /* Initialisation   */
   CB := CB + "^FT0,120^A0N,32,32^FH\^FD"		  + Fill("_",12)     + "^FS" + chr(10);                 /* Limite basse     */
   CB := CB + "^FT185,120^A0B,35,35^FH\^FD"       + Fill("_",20)     + "^FS" + chr(10);                 /* Limite droite    */
   CB := CB + "^FT40,70^A0N,25,25^FH\^FD"	        + sId              + "^FS" + chr(10);                 /* ID               */ 
   CB := CB + "^FT28,3^A0N,22,22^FH\^FD"		  + sLN              + "^FS" + chr(10);                 /* Nom de famille   */
   CB := CB + "^FT28,24^A0N,22,22^FH\^FD"		  + sFN              + "^FS" + chr(10);                 /* Prenom           */
   CB := CB + "^FWR^FO23,9,120^A0B,19,19^FD"	  + sStorage         + "^FS" + chr(10);                 /* Biothèque        */
   CB := CB + "^LRY^FO1,0^GB21,130,20^FS^LRN"                        + "^FS" + chr(10);                 /* SQ Biothèque     */ 
   CB := CB + "^FT25,43^A0N,20,17^FH\^FD"         + sDDN             + "^FS" + chr(10);                 /* Date de naissance*/
   CB := CB + "^FT37,10^A0N,25,25^FH\^FD"         + sLAB             + "^FS" + chr(10);                 /* Attribut Label   */ 
   CB := CB + "^FT25,120^A0N,20,20^FH\^FD"	  + sPrel            + "^FS" + chr(10);                 /* Date prelèvement */
   CB := CB + "^FT25,100^A0N,25,25^FH\^FD"        + sMatS            + "^FS" + chr(10);                 /* Sampling  CODE   */
   CB := CB + "^LRY^FO110,103^GB85,25,18^FS^LRN"                             + chr(10);                 /* SQ Sampling Code */
   CB := CB + "^LRY^FO32,45^GB135,32,18^FS^LRN"	  	                       + chr(10);                 /* SQ ID            */
   CB := CB + "^FO35,80^BY1.4^BCN,40,N,N,N^FD"    + sId              + "^FS" + chr(10);                 /* EAN 128          */
   CB := CB + "^FT25,36^A0N,21,21^FH\^FD"	        + sRosa            + "^FS" + chr(10);                 /* Inclusion ROSA   */
   CB := CB + "^FT35,120^A0N,20,20^FH\^FD"        + sPlan            + "^FS" + chr(10);                 /* Approche         */
   CB := CB + "^FT$225,90^A0N,25,25^FH\^FD"       + Fill("-",7)      + "^FS" + chr(10);                 /* Limite [C] ONCO  */

/** 
Les paramètres ^FO et ^FT sont modifiés pour exclure les variables non pertinentes de la zone d'impression pour chaque POOL de matériels concernés.
Les paramètres ^GB , ^LWR, ^LRY, ^BCN, sont ajustés en fonction du matériel pour limiter le nombre de déclaration. 
Choisir un type d'étiquette dans l'attribut configurable.
**/

/*______________________________________________________________________________________ ETIQUETTES DOSSIER _____________________________________________________________________________________*/   
                                                                                 
IF sTypo = "DOSSIER" THEN
   CB := Replace(Replace(Replace(Replace(Replace(CB,sMats,""),sPrel,""),"^FT25,36","^FT335,36"),"19^FD","19^FD" + "DOSSIER"),"BCN,40","BCN,20");
   CB := Replace(CB,"^FO110","^FO300");
ENDIF;
/*________________________________________________________________________ ETIQUETTES BIONANO -80°C et ACHEMINEMENT ____________________________________________________________________________*/ 

IF Substr(sMM,9,15) = "BIONANO" THEN
    CB := Replace(Replace(Replace(Replace(Replace(Replace(CB,sLN,cPad("Projet",19," ")),sFN,cPad("BIONANO",19," ")),sDDN,cPad("Stockage -80C",19," ")),"^FO35","^FO335"),"^FT25,36","^FT335,36"),"^FT35,120","^FT335,120");
    CB := Replace(CB,"^FO110","^FO300");
ENDIF;

IF sTypo = "PROJET" THEN 
    CB := Replace(Replace(Replace(Replace(Replace(CB,"^FT25,36","^FT335,36"),"^FO35","^FO335"),"^FT35,120","^FT335,120"),"^LRY^FO32","^LRY^FO332"),"^FWR^FO23,9","^FWR^FO23,30");
    CB := Replace(Replace(Replace(Replace(CB,"^FO110,103^GB85,25,18^","^FO1,78^GB190,30,50^"),"^FT25,100^A0N,25,25","^FT33,100^A0N,22,22"),"GB21,130","GB23,127"),"19^FD","19^FD" + "66h>  " + sDelai) ;
ENDIF;
/*____________________________________________________________________________________ ETIQUETTES TUBES EDTA ___________________________________________________________________________________*/ 

IF sTypo = "NEURO QIA" THEN 
   CB := Replace(Replace(Replace(Replace(Replace(CB,sPrel,""),sMatS,""),"^FT37,10^A0N,25,25","^FT164,67^A0N,22,22"),"^GB135" ,"^GB165"),"^FT25,36","^FT335,36");
   CB := Replace(CB,"^FO110","^FO300");   	        
ENDIF;

/*____________________________________________________________________________________ ETIQUETTES PROJET ROSA __________________________________________________________________________________*/ 

IF sTypo = "ROSA" THEN
   CB := Replace(Replace(Replace(Replace(Replace(Replace(CB,sDDN,""),sLN,""),sFN,""),"^FO35","^FO335"),"^FT35,120","^FT335,120"),"^FO110","^FO300");    
ENDIF;

/*_____________________________________________________________________________ ETIQUETTES DILUTIONS ADN et ARN SM _____________________________________________________________________________*/

IF sTypo = "NEURO STD" THEN
  CB := Replace(Replace(Replace(CB,"^FT25,36","^FT335,36"),"^FT25,120","^FT335,120"),"BCN,40","BCN,20") ;
  CB := Replace(CB,"^FT25,100^A0N,25,25^FH\^FD","^FT100,120^A0N,16,16^FH\^FD");
ENDIF;

/*_____________________________________________________________________________ ETIQUETTES ONCOSOMATIQUE TUMEURS SOLIDES ________________________________________________________________________*/

IF sTypo = "ONCOS" THEN
  CB := Replace(Replace(Replace(Replace(Replace(CB,"^FO35","^FO335"),"FT25,100","FT225,10"),"FT35","FT335"),"^FO32,45^GB135","^FO118,45^GB55"),sPrel,"[C]:" + Fill(" ",15) + "ng/ul" );
  CB := Replace(Replace(CB,Substr(sId,7,7),"." + Substr(sId,7,7)),"FO110,103^GB85","FO132,103^GB55");
  CB := Replace(CB,"$225","25");
ENDIF;

RETURN CB + "^PQ" + GetSiteAttribute("Material",.Material.Id,"NB")  +",0,5,Y^XB^XZ" + chr(10);}




