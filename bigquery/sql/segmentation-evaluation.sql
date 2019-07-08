#standardSQL

select * from ml.evaluate(model `__REPLACE_ME__.segmentation_model`, table `__REPLACE_ME__.segmentation_training_set`)

