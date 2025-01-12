'use strict';

var express = require('express');
var controller = require('./Determination.controller');
var voteController = require('../DeterminationVotes/DeterminationVotes.controller');
var logController = require('../DeterminationLog/DeterminationLog.controller');


var auth = require('../../../auth/auth.service');

var router = express.Router();

router.get('/', controller.index);

router.get('/:id', controller.show);
router.get('/:id/logs', auth.hasRole('validator'),  logController.getLogForDetermination);



router.post('/', auth.hasRole('validator'), controller.create);
router.put('/:id',auth.hasRole('validator'),  controller.update);
router.put('/:id/validation', auth.hasRole('validator'),  controller.updateValidation);
router.patch('/:id',auth.hasRole('validator'),  controller.update);

router.post('/:id/votes',auth.appendUser(), voteController.addVoteToDetermination);
router.put('/:id/confidence', auth.isAuthenticated(),    controller.updateConfidence);
router.delete('/:id/votes/:userid',auth.appendUser(), voteController.deleteVoteFromDetermination);
router.delete('/:id', auth.isAuthenticated(),   controller.destroy);




module.exports = router;
