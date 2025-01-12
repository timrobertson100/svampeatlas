CREATE VIEW CurrentRedListStatus AS SELECT taxon_id, status, year FROM TaxonRedListData WHERE year= (SELECT MAX(year) FROM TaxonRedListData);
ALTER TABLE `TaxonRedListData` ADD KEY `Status` (`Status`);
ALTER TABLE `Determination` ADD KEY `validation` (`validation`);


CREATE VIEW DeterminationView AS SELECT 
d._id as Determination_id ,
d.createdAt as Determination_createdAt ,
d.updatedAt as Determination_updatedAt ,
d.observation_id as Determination_observation_id ,
d.taxon_id as Determination_taxon_id ,
d.user_id as Determination_user_id ,
d.confidence as Determination_confidence ,
d.score as Determination_score ,
d.validation as Determination_validation ,
d.notes as Determination_notes ,
d.validatorremarks as Determination_validatorremarks ,
d.validator_id as Determination_validator_id ,
d.verbatimdeterminator as Determination_verbatimdeterminator ,
t._id as Taxon_id ,
 t.createdAt Taxon_createdAt ,
  t.updatedAt Taxon_updatedAt ,
  t.Path Taxon_Path ,
  t.SystematicPath Taxon_SystematicPath ,
  t.Version Taxon_Version ,
  t.FullName Taxon_FullName ,
  t.GUID Taxon_GUID ,
  t.FunIndexTypificationNumber Taxon_FunIndexTypificationNumber ,
  t.FunIndexCurrUseNumber Taxon_FunIndexCurrUseNumber ,
  t.FunIndexNumber Taxon_FunIndexNumber ,
  t.RankID Taxon_RankID ,
  t.RankName Taxon_RankName ,
  t.TaxonName Taxon_TaxonName ,
  t.Author Taxon_Author ,
  n.vernacularname_dk Taxon_vernacularname_dk ,
  t.parent_id Taxon_parent_id ,
  t.accepted_id Taxon_accepted_id,
  t2.FullName Recorded_as_FullName,
  t2._id Recorded_as_id,
  r.status Taxon_redlist_status  
FROM  (Determination d JOIN Taxon t2
ON  t2._id=d.taxon_id JOIN Taxon t ON t2.accepted_id=t._id LEFT JOIN TaxonDKnames n ON t.vernacularname_dk_id = n._id) LEFT JOIN CurrentRedListStatus r ON r.taxon_id=t._id;

SHOW CREATE VIEW DeterminationView2;
DROP VIEW IF EXISTS DeterminationView2;
CREATE VIEW DeterminationView2 AS SELECT 
d._id as Determination_id ,
d.createdAt as Determination_createdAt ,
d.updatedAt as Determination_updatedAt ,
d.observation_id as Determination_observation_id ,
d.taxon_id as Determination_taxon_id ,
d.species_hypothesis as Determination_species_hypothesis,
d.sh_identity as Determination_sh_identity,
d.user_id as Determination_user_id ,
d.confidence as Determination_confidence ,
d.score as Determination_score ,
d.validation as Determination_validation ,
d.notes as Determination_notes ,
d.validatorremarks as Determination_validatorremarks ,
d.validator_id as Determination_validator_id ,
d.verbatimdeterminator as Determination_verbatimdeterminator ,
t._id as Taxon_id ,
 t.createdAt Taxon_createdAt ,
  t.updatedAt Taxon_updatedAt ,
  t.Path Taxon_Path ,
  t.SystematicPath Taxon_SystematicPath ,
  t.Version Taxon_Version ,
  t.FullName Taxon_FullName ,
  t.GUID Taxon_GUID ,
  t.FunIndexTypificationNumber Taxon_FunIndexTypificationNumber ,
  t.FunIndexCurrUseNumber Taxon_FunIndexCurrUseNumber ,
  t.FunIndexNumber Taxon_FunIndexNumber ,
  t.RankID Taxon_RankID ,
  t.RankName Taxon_RankName ,
  t.TaxonName Taxon_TaxonName ,
  t.Author Taxon_Author ,
  n.vernacularname_dk Taxon_vernacularname_dk ,
  t.parent_id Taxon_parent_id ,
  t.accepted_id Taxon_accepted_id,
  t.morphogroup_id Taxon_morphogroup_id,
  t2.FullName Recorded_as_FullName,
  t2._id Recorded_as_id,
  r.status Taxon_redlist_status,
  cv1.CharacterID IS NOT NULL as mycorrhizal,
  cv2.CharacterID IS NOT NULL as lichenized,
  cv3.CharacterID IS NOT NULL as parasite,
  cv4.CharacterID IS NOT NULL as saprobe,
  cv5.CharacterID IS NOT NULL as on_lichens,
  cv6.CharacterID IS NOT NULL as on_wood
FROM  (Determination d JOIN Taxon t2
ON  t2._id=d.taxon_id JOIN Taxon t ON t2.accepted_id=t._id LEFT JOIN TaxonDKnames n ON t.vernacularname_dk_id = n._id 
LEFT JOIN CharacterView cv1 ON (t._id = cv1.taxon_id AND cv1.CharacterID = 381) 
LEFT JOIN CharacterView cv2 ON (t._id = cv2.taxon_id AND cv2.CharacterID = 380)
LEFT JOIN CharacterView cv3 ON (t._id = cv3.taxon_id AND cv3.CharacterID = 382)
LEFT JOIN CharacterView cv4 ON (t._id = cv4.taxon_id AND cv4.CharacterID = 385)
LEFT JOIN CharacterView cv5 ON (t._id = cv5.taxon_id AND cv5.CharacterID = 404)
LEFT JOIN CharacterView cv6 ON (t._id = cv6.taxon_id AND cv6.CharacterID = 412)
) LEFT JOIN CurrentRedListStatus r ON r.taxon_id=t._id ;

DROP VIEW IF EXISTS DeterminationView2;
CREATE VIEW `DeterminationView2` AS select 
`d`.`_id` AS `Determination_id`,
`d`.`createdAt` AS `Determination_createdAt`,
`d`.`updatedAt` AS `Determination_updatedAt`,
`d`.`observation_id` AS `Determination_observation_id`,
`d`.`taxon_id` AS `Determination_taxon_id`,
`d`.`species_hypothesis` as `Determination_species_hypothesis`,
`d`.`sh_identity` as `Determination_sh_identity`,
`d`.`user_id` AS `Determination_user_id`,
`d`.`confidence` AS `Determination_confidence`,
`d`.`score` AS `Determination_score`,
`d`.`validation` AS `Determination_validation`,
`d`.`notes` AS `Determination_notes`,
`d`.`validatorremarks` AS `Determination_validatorremarks`,
`d`.`validator_id` AS `Determination_validator_id`,
`d`.`verbatimdeterminator` AS `Determination_verbatimdeterminator`,
`t`.`_id` AS `Taxon_id`,
`t`.`createdAt` AS `Taxon_createdAt`,
`t`.`updatedAt` AS `Taxon_updatedAt`,
`t`.`Path` AS `Taxon_Path`,
`t`.`SystematicPath` AS `Taxon_SystematicPath`,
`t`.`Version` AS `Taxon_Version`,
`t`.`FullName` AS `Taxon_FullName`,
`t`.`GUID` AS `Taxon_GUID`,
`t`.`FunIndexTypificationNumber` AS `Taxon_FunIndexTypificationNumber`,
`t`.`FunIndexCurrUseNumber` AS `Taxon_FunIndexCurrUseNumber`,
`t`.`FunIndexNumber` AS `Taxon_FunIndexNumber`,
`t`.`RankID` AS `Taxon_RankID`,
`t`.`RankName` AS `Taxon_RankName`,
`t`.`TaxonName` AS `Taxon_TaxonName`,
`t`.`Author` AS `Taxon_Author`,
`n`.`vernacularname_dk` AS `Taxon_vernacularname_dk`,
`t`.`parent_id` AS `Taxon_parent_id`,
`t`.`accepted_id` AS `Taxon_accepted_id`,
`t`.`morphogroup_id` AS `Taxon_morphogroup_id`,
`t2`.`FullName` AS `Recorded_as_FullName`,
`t2`.`_id` AS `Recorded_as_id`,
`r`.`status` AS `Taxon_redlist_status`,
(`cv1`.`CharacterID` is not null) AS `mycorrhizal`,
(`cv2`.`CharacterID` is not null) AS `lichenized`,
(`cv3`.`CharacterID` is not null) AS `parasite`,
(`cv4`.`CharacterID` is not null) AS `saprobe`,
(`cv5`.`CharacterID` is not null) AS `on_lichens`,
(`cv6`.`CharacterID` is not null) AS `on_wood` 
from ((((((((((`Determination` `d` join `Taxon` `t2` on((`t2`.`_id` = `d`.`taxon_id`))) join `Taxon` `t` on((`t2`.`accepted_id` = `t`.`_id`))) left join `TaxonDKnames` `n` on((`t`.`vernacularname_dk_id` = `n`.`_id`))) left join `CharacterView` `cv1` on(((`t`.`_id` = `cv1`.`taxon_id`) and (`cv1`.`CharacterID` = 381)))) left join `CharacterView` `cv2` on(((`t`.`_id` = `cv2`.`taxon_id`) and (`cv2`.`CharacterID` = 380)))) left join `CharacterView` `cv3` on(((`t`.`_id` = `cv3`.`taxon_id`) and (`cv3`.`CharacterID` = 382)))) left join `CharacterView` `cv4` on(((`t`.`_id` = `cv4`.`taxon_id`) and (`cv4`.`CharacterID` = 385)))) left join `CharacterView` `cv5` on(((`t`.`_id` = `cv5`.`taxon_id`) and (`cv5`.`CharacterID` = 404)))) left join `CharacterView` `cv6` on(((`t`.`_id` = `cv6`.`taxon_id`) and (`cv6`.`CharacterID` = 412)))) left join `CurrentRedListStatus` `r` on((`r`.`taxon_id` = `t`.`_id`));





CREATE VIEW `DeterminationView2` AS select 
`d`.`_id` AS `Determination_id`,
`d`.`createdAt` AS `Determination_createdAt`,
`d`.`updatedAt` AS `Determination_updatedAt`,
`d`.`observation_id` AS `Determination_observation_id`,
`d`.`taxon_id` AS `Determination_taxon_id`,
`d`.`user_id` AS `Determination_user_id`,
`d`.`confidence` AS `Determination_confidence`,
`d`.`score` AS `Determination_score`,
`d`.`validation` AS `Determination_validation`,
`d`.`notes` AS `Determination_notes`,
`d`.`validatorremarks` AS `Determination_validatorremarks`,
`d`.`validator_id` AS `Determination_validator_id`,
`d`.`verbatimdeterminator` AS `Determination_verbatimdeterminator`,
`t`.`_id` AS `Taxon_id`,
`t`.`createdAt` AS `Taxon_createdAt`,
`t`.`updatedAt` AS `Taxon_updatedAt`,
`t`.`Path` AS `Taxon_Path`,
`t`.`SystematicPath` AS `Taxon_SystematicPath`,
`t`.`Version` AS `Taxon_Version`,
`t`.`FullName` AS `Taxon_FullName`,
`t`.`GUID` AS `Taxon_GUID`,
`t`.`FunIndexTypificationNumber` AS `Taxon_FunIndexTypificationNumber`,
`t`.`FunIndexCurrUseNumber` AS `Taxon_FunIndexCurrUseNumber`,
`t`.`FunIndexNumber` AS `Taxon_FunIndexNumber`,
`t`.`RankID` AS `Taxon_RankID`,
`t`.`RankName` AS `Taxon_RankName`,
`t`.`TaxonName` AS `Taxon_TaxonName`,
`t`.`Author` AS `Taxon_Author`,
`n`.`vernacularname_dk` AS `Taxon_vernacularname_dk`,
`t`.`parent_id` AS `Taxon_parent_id`,
`t`.`accepted_id` AS `Taxon_accepted_id`,
`t`.`morphogroup_id` AS `Taxon_morphogroup_id`,
`t2`.`FullName` AS `Recorded_as_FullName`,
`t2`.`_id` AS `Recorded_as_id`,
`r`.`status` AS `Taxon_redlist_status`,
(`cv1`.`CharacterID` is not null) AS `mycorrhizal`,
(`cv2`.`CharacterID` is not null) AS `lichenized`,
(`cv3`.`CharacterID` is not null) AS `parasite`,
(`cv4`.`CharacterID` is not null) AS `saprobe`,
(`cv5`.`CharacterID` is not null) AS `on_lichens`,
(`cv6`.`CharacterID` is not null) AS `on_wood` 
from ((((((((((`Determination` `d` join `Taxon` `t2` on((`t2`.`_id` = `d`.`taxon_id`))) join `Taxon` `t` on((`t2`.`accepted_id` = `t`.`_id`))) left join `TaxonDKnames` `n` on((`t`.`vernacularname_dk_id` = `n`.`_id`))) left join `CharacterView` `cv1` on(((`t`.`_id` = `cv1`.`taxon_id`) and (`cv1`.`CharacterID` = 381)))) left join `CharacterView` `cv2` on(((`t`.`_id` = `cv2`.`taxon_id`) and (`cv2`.`CharacterID` = 380)))) left join `CharacterView` `cv3` on(((`t`.`_id` = `cv3`.`taxon_id`) and (`cv3`.`CharacterID` = 382)))) left join `CharacterView` `cv4` on(((`t`.`_id` = `cv4`.`taxon_id`) and (`cv4`.`CharacterID` = 385)))) left join `CharacterView` `cv5` on(((`t`.`_id` = `cv5`.`taxon_id`) and (`cv5`.`CharacterID` = 404)))) left join `CharacterView` `cv6` on(((`t`.`_id` = `cv6`.`taxon_id`) and (`cv6`.`CharacterID` = 412)))) left join `CurrentRedListStatus` `r` on((`r`.`taxon_id` = `t`.`_id`))

