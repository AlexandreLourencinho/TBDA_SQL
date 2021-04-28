/*1)Quelles sont les commandes du fournisseur 09120?------------------------------------------------------------------------------*/

SELECT  numcom as "numéro de commande", numfou as "numéro de fournisseur"
FROM    entcom 
WHERE   numfou=9120



/*2)Afficher le code des fournisseurs pour lesquels des 
commandes ont été passées.-------------------------------------------------------------------------------------------------------*/

/* cette solution MARCHAIT TRES BIEN ^^*/
SELECT DISTINCT numfou 
FROM            entcom
/* avec consignes en + : ET LEURS NOMS*/

SELECT DISTINCT entcom.numfou as "numéro fournisseur", nomfou as "nom fournisseur"

from            entcom 
join            fournis 
on              entcom.numfou = fournis.numfou



/*3)Afficher le nombre de commandes fournisseurs passées, 
et le nombre de fournisseur concernés.------------------------------------------------------------------------------------------*/


SELECT  COUNT(numcom) as "nombre_commandes", count(distinct numfou) as "nombre_fournisseurs" 

from    entcom



/*4)Editer les produits ayant un stock inférieur(stkphy) ou 
égal au stock d'alerte(stkale) et dont la quantité annuelle(qteann) est 
inférieur à 1000 (informations à fournir : 
n° produit(codart), libelléproduit(libart), stock(stkphy), 
stockactuel d'alerte (stkale), 
quantitéannuelle(qteann))-------------------------------------------------------------------------------------------------------*/


SELECT      codart as "numero article", 
            libart as "libelle article", 
            stkphy as "stock physique", 
            stkale as "stock d'alerte",    
            qteann as "quantite annuelle"

from        produit

where       stkphy<=stkale 
AND         qteann<1000




/*5)Quels sont les fournisseurs situés dans les
 départements 75 78 92 77 ? 
L’affichage (département, nom fournisseur) 
sera effectué par département décroissant, 
puis par ordre alphabétique------------------------------------------------------------------------------------------------------*/

SELECT      left(posfou,2) as "département", nomfou as "nom fournisseur"

from        fournis

where       posfou like "92%" 
or          posfou like "75%" 
or          posfou like "78%" 
or          posfou like "77%"

ORDER BY    posfou DESC, nomfou ASC


/*6)Quelles sont les commandes passées au mois de mars et avril?------------------------------------------------------------------*/



SELECT  numcom as 'commandes entre mars et avril'

from    entcom 

where   month(datcom) between 03 and 04



/*7)Quelles sont les commandes du jour qui ont des observations 
particulières ?(Affichage numéro de commande, date de commande)--------------------------------------------------------------------*/



SELECT  numcom as "numéro de commande", datcom as "date de commande"

from    entcom 

where   obscom is not null 
and     obscom <> " "
AND     obscom <> ""



/*8)Lister le total de chaque commande par total décroissant 
(Affichage numéro de commande et total)----------------------------------------------------------------------------------------------*/


SELECT      nomfou as "nom fournisseur", ligcom.numcom, SUM(QTECDE * PRIUNI) as "Total des commandes"

from        ligcom
join        entcom on ligcom.numcom = entcom.numcom
join        fournis on entcom.numfou = fournis.numfou

GROUP BY    ligcom.numcom
order BY    SUM(QTECDE * PRIUNI) desc



/*9)Lister les commandes dont le total est supérieur à 10000€; 
on exclura dans le calcul du total les articles commandés en 
quantité supérieure ou égale à 1000.(Affichage numéro de 
commande et total)---------------------------------------------------------------------------------------------------------------------*/



SELECT      nomfou as "nom fournisseur", ligcom.numcom as "numéro de commande", SUM(QTECDE * PRIUNI) as "TOTAL"

from        ligcom

join        entcom on ligcom.numcom = entcom.numcom
join        fournis on entcom.numfou = fournis.numfou

where       qtecde<1000  

GROUP BY    ligcom.numcom

HAVING      TOTAL>10000

order BY    TOTAL DESC




/*10)Lister les commandes par nom fournisseur 
(Afficher le nom du fournisseur, 
le numéro de commande et la date)--------------------------------------------------------------------------------------------------------*/


SELECT      nomfou as "nom fournisseur", entcom.numcom as "numéro de commande", datcom as "date de commande"

from        entcom

join        fournis on entcom.numfou = fournis.numfou

group by    numcom
order by 	nomfou




/*11)Sortir les produits des commandes ayant le mot "urgent" 
en observation?(Afficher le numéro de commande, 
le nom du fournisseur, le libellé du produit et le sous 
total= quantité commandée * Prix unitaire)------------------------------------------------------------------------------------------------*/





SELECT      nomfou as "nom fournisseur", 
            libart as "libellé article", ligcom.codart as "code article", 
            ligcom.numcom as "numéro commande", sum(qtecde*priuni) as "sous-total"

from        ligcom

join        entcom on ligcom.numcom = entcom.numcom
join        fournis on entcom.numfou = fournis.numfou
join        produit on ligcom.codart = produit.codart

where       obscom like "%urgent%"
group by 	ligcom.numcom, nomfou, libart




/*12)Coder de 2manières différentes la requête suivante:
Lister le nom des fournisseurs susceptibles de livrer au moins 
un article----------------------------------------------------------------------------------------------------------------------------------*/


SELECT DISTINCT     nomfou as "nom fournisseur"

from                fournis

join                entcom on fournis.numfou = entcom.numfou
join                ligcom on entcom.numcom = ligcom.numcom

where               qteliv < qtecde
/* deuxième manière*/
SELECT DISTINCT     nomfou as "nom fournisseur"

from                fournis,entcom,ligcom

where               fournis.numfou=entcom.numfou 
and                 entcom.numcom=ligcom.numcom 
and                 qteliv < qtecde


/*13)Coder de 2 manières différentes la requête suivante
Lister les commandes (Numéro et date) dont le fournisseur est
 celui de la commande 70210--------------------------------------------------------------------------------------------------------------------*/


select      numcom as "numéro de commande", datcom as "date de commande"
from        entcom 
where       numfou = (
                        select          numfou 
                        from            entcom 
                        where           numcom = 70210
)
/*deuxième manière ------------------------------------------------------------------------------------------------------------------------------*/

select      numcom as "numéro de commande", datcom as "date de commande"
from        entcom
join        fournis on entcom.numfou = fournis.numfou
where       entcom.numfou = (
                                select      entcom.numfou
                                from        entcom
                                where       entcom.numcom = 70210
                            )


/*14)Dans les articles susceptibles d’être vendus, 
lister les articles moins chers (basés sur Prix1) que le moins 
cher des rubans (article dont le premier caractère commence par R). 
On affichera le libellé de l’article et prix1.------------------------------------------------------------------------------------------------------*/



SELECT      vente.codart, libart, prix1
from        vente, produit
where       produit.codart=vente.codart
and         vente.prix1 < 
                            (
                                SELECT      MIN(prix1)
                                from        vente
                                where       vente.codart like "R%"
                            )
group by    codart





/*15)Editer la liste des fournisseurs susceptibles de livrer 
les produits dont le stock est inférieur ou égal à 150 % du stock 
d'alerte'. La liste est triée par produit puis fournisseur ------------------------------------------------------------------------------------------*/



SELECT      fournis.nomfou as "nom fournisseur", 
            vente.numfou as "numéro fournisseur", 
            produit.libart as "libellé article", 
            vente.codart as "code article"

FROM        fournis, produit, vente

where 	    fournis.numfou = vente.numfou
and 	    produit.codart = vente.codart
and	        produit.stkphy<=1.5*produit.stkale

group by    vente.codart, nomfou

order by    vente.codart, nomfou



/*16)Éditer la liste des fournisseurs susceptibles 
de livrer les produit dont le stock est inférieur ou 
égal à 150 % du stock d'alerte et un délai de livraison 
d'au plus 30 jours. La liste est triée par 
fournisseur puis produit -----------------------------------------------------------------------------------------------------------------------------*/



SELECT      fournis.nomfou as "nom fournisseur", 
            vente.numfou as "numéro fournisseur", 
            produit.libart as "libellé article", 
            vente.codart as "code article"

FROM        fournis, produit, vente

where 	    fournis.numfou = vente.numfou
and 	    produit.codart = vente.codart
and	        produit.stkphy<=1.5*produit.stkale
and 	    delliv<=30

group by    vente.codart, nomfou

order by    vente.codart, nomfou




/*17)Avec le même type de sélection que ci-dessus, 
sortir un total des stocks par fournisseur trié 
par total décroissant------------------------------------------------------------------------------------------------------------------------------------*/



select      sum(produit.stkphy) as stock, fournis.nomfou as "nom fournisseur", fournis.numfou as "numéro fournisseur"

from        vente, fournis, produit

where       produit.codart=vente.codart
AND			vente.numfou = fournis.numfou

group by    nomfou

order by    stock DESC



/*18)En fin d'année, sortir la liste des produits 
dont la quantité réellement commandée dépasse 90% de la 
quantité annuelle prévue.------------------------------------------------------------------------------------------------------------------------------------*/


SELECT      ligcom.codart as "produits avec quantitécommandée >90% de la quantité annuelle", 
            produit.libart as "libellé de l'article"

from        ligcom, produit

where       qtecde>0.9*qteann
AND         ligcom.codart=produit.codart

group by    ligcom.codart


/*19)Calculer le chiffre d'affaire par fournisseur pour l'année 2018 
sachant que les prix indiqués sont hors taxes et que le taux de 
TVA est 20%.-----------------------------------------------------------------------------------------------------------------------------------------------*/


select      sum(qtecde*priuni*1.2) as total, nomfou as "nom fournisseur"

from        ligcom, fournis, entcom

where       ligcom.numcom = entcom.numcom
and         entcom.numfou = fournis.numfou
and         year(datcom) = 2018

group by    nomfou
order by 	total desc




/*LES BESOINS DE MISE A JOUR--------------------------------------------------------------------------------------------------------------------------------*/

/*20)//1)Application d'une augmentation de tarif de 4% 
pour le prix 1, 2% pour le prix2 pour le fournisseur 9180---------------------------------------------------------------------------------------------------*/



update  vente

set     prix1 = prix1*1.04 , prix2= prix2*1.02

where   numfou=9180




/*21)//2)Dans la table vente, mettre à jour le prix2 
des articles dont le prix2 est null, 
en affectant a valeur de prix.-----------------------------------------------------------------------------------------------------------------------------*/


update      vente

set         prix2=prix1

where       prix2=0




/*22)//3)Mettre à jour le champ obscom en positionnant 
'*****' pour toutes les commandes dont le fournisseur 
a un indice de satisfaction <5-----------------------------------------------------------------------------------------------------------------------------*/




update      entcom, fournis

set         obscom="*****"

where       entcom.numfou = fournis.numfou
and         fournis.satisf<5






/*23)//4)Suppression du produit I110-----------------------------------------------------------------------------------------------------------------------*/

/*première*/
delete from     produit
where           codart = "I110";
/* deuxième*/
delete from     vente

where           codart="I110";
