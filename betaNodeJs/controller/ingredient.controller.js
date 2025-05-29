const IngredientService = require('../services/ingredient.services');

exports.addIngredient = async (req, res) => {
  try {
    const { name, quantity, userId } = req.body;
    console.log('BODY:', req.body);
    const result = await IngredientService.addIngredient(userId, name, quantity);
    res.status(201).json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getIngredients = async (req, res) => {
  try {
    const { userId } = req.query;
    const ingredients = await IngredientService.getIngredientsByUser(userId);
    res.status(200).json(ingredients);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
