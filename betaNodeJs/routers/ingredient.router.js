const router = require('express').Router();
const IngredientController = require('../controller/ingredient.controller');

router.post('/ingredient', IngredientController.addIngredient);
router.get('/ingredient', IngredientController.getIngredients);

module.exports = router;
