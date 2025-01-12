/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /taxons              ->  index
 * POST    /taxons              ->  create
 * GET     /taxons/:id          ->  show
 * PUT     /taxons/:id          ->  update
 * DELETE  /taxons/:id          ->  destroy
 */

'use strict';

var _ = require('lodash');

var models = require('../')
var ObservationForum = models.ObservationForum;
var ObservationEvent = models.ObservationEvent;
var ObservationEventMention = models.ObservationEventMention;
var ObservationSubscriber = models.ObservationSubscriber;
var Promise = require("bluebird");

var nestedQueryParser = require("../nestedQueryParser")

function handleError(res, statusCode) {
	statusCode = statusCode || 500;
	return function(err) {
		console.log(err);
		res.status(statusCode).send(err);
	};
}

function responseWithResult(res, statusCode) {
	statusCode = statusCode || 200;
	return function(entity) {
		if (entity) {
			return res.status(statusCode).json(entity)
		}
	};
}

function handleEntityNotFound(res) {
	return function(entity) {
		if (!entity) {
			res.send(404);
			return null;
		}
		return entity;
	};
}

function saveUpdates(updates) {
	return function(entity) {
		return entity.updateAttributes(updates)
			.then(function(updated) {
				return updated;
			});
	};
}

function removeEntity(res) {
	return function(entity) {
		if (entity) {
			return entity.destroy()
				.then(function() {
					return res.send(204);
				});
		}
	};
}

// Get list of taxons
exports.index = function(req, res) {


	var query = {
		offset: req.query.offset,
		limit: req.query.limit,
		order: req.query.order,
		where: {}
	};

	

	if (req.query.where) {
		_.merge(query.where, JSON.parse(req.query.where));
	}

	if (req.query.include) {
		var include = JSON.parse(req.query.include)

		query['include'] = _.map(include, function(n) {
			n.model = models[n.model];
			if (n.where) {
				n.where = JSON.parse(n.where);

				if (n.where.$and && n.where.$and.length > 0) {

					for (var i = 0; i < n.where.$and.length; i++) {
						n.where.$and[i] = JSON.parse(n.where.$and[i]);
					}
				}
				/*
				if(n.model === "TaxonomyTag"){

							n.where._id = JSON.parse(n.where._id);
				
				}
				*/

				//	n.where = nestedQueryParser.parseQueryString(n.where)

			}
			console.log(n.where)
			return n;
		});
		
	
	}

	
	ObservationForum.findAndCount(query)
		.then(function(taxon) {
			res.set('count', taxon.count);
			if (req.query.offset) {
				res.set('offset', req.query.offset);
			};
			if (req.query.limit) {
				res.set('limit', req.query.limit);
			};
			return res.status(200).json(taxon.rows)
		})
		.
	catch (handleError(res));
	
};


// Get a single taxon
exports.show = function(req, res) {
	ObservationForum.find({
		where: {
			_id: req.params.id
		} /*,
		include: [{
				model: models.TaxonImages,
				as: "images"
			}, {
				model: models.TaxonSpeciesHypothesis,
				as: 'specieshypothesis'
			},
			{
				model: models.Taxon,
				as: "synonyms"
			}, {
				model: models.Taxon,
				as: "Parent"
			}, {
				model: models.Taxon,
				as: "acceptedTaxon"
			}, {
				model: models.TaxonAttributes,
				as: "attributes"
			}, {
				model: models.Naturtype,
				as: 'naturtyper'
			}, {
				model: models.ErnaeringsStrategi,
				as: 'nutritionstrategies'
			}, {
				model: models.TaxonomyTag,
				as: 'tags'
			}

		] */
	})
		.then(handleEntityNotFound(res))
		.then(responseWithResult(res))
		.
	catch (handleError(res));
};


exports.showForumForObs = function(req, res) {
	ObservationForum.findAll({
		where: {
			observation_id: req.params.id
		} ,
		include: [{
				model: models.User,
				as: 'User'
			}]
	})
		.then(handleEntityNotFound(res))
		.then(responseWithResult(res))
		.
	catch (handleError(res));
}

exports.addCommentToObs = (req, res) => {
	var comment = req.body;
	var postedmentions = (req.body.mentions) ? req.body.mentions : [];
	comment.observation_id = req.params.id;
	comment.user_id = req.user._id;

ObservationForum.create(comment)
	.then(function(comment){
		return [comment, ObservationEvent.create({
			eventType: 'COMMENT_ADDED',
			user_id: req.user._id,
			observation_id: req.params.id
		}), ObservationSubscriber.upsert({
			user_id: req.user._id,
			observation_id: req.params.id,
			updatedAt: models.sequelize.fn('NOW')
		})]
	})
	.spread(function(comment, event, subscriber){
		
		var mentions = _.map(_.uniqBy(postedmentions, '_id') , function(u){
			
			return {observationevent_id: event._id, user_id: u._id, observation_id: req.params.id};
		})
	
		
		return [comment, ObservationEventMention.bulkCreate(mentions)]
			.concat(_.map(mentions, function(m){
				return ObservationSubscriber.upsert({
			user_id: m.user_id,
			observation_id: req.params.id
		})
			}))
	})
	.spread(function(comment){
		return ObservationForum.find({
		where: {
			_id: comment._id
		} ,
		include: [{
				model: models.User,
				as: 'User'
			}]
	})
	})
    .then(function(comment){
    	return res.status(201).json(comment)
    })
    .catch(handleError(res));	
}

// Creates a new taxon in the DB.
exports.create = function(req, res) {

};



// Updates an existing taxon in the DB.
exports.update = function(req, res) {

	
};


// Deletes a taxon from the DB.
exports.destroy = function(req, res) {
	ObservationForum.find({
		where: {
			_id: req.params.id
		}
	})
		.then(handleEntityNotFound(res))
		.then(removeEntity(res))
		.
	catch (handleError(res));
};


