-- =====================================================
-- Dev Panchal - Assignment Part 2 Assignment
-- =====================================================

USE recipes;

-- =====================================================
-- INSERT NEW CATEGORIES
-- =====================================================

-- Insert Beverage category for Masala Chai
INSERT INTO categories (category_name) 
VALUES ('Beverage');

-- Inserted Bread category for Aloo Paratha
INSERT INTO categories (category_name) 
VALUES ('Bread');

-- =====================================================
-- INSERTING NEW RECIPES INTO recipe_main
-- =====================================================

-- Recipe 3: Masala Chai (Indian Spiced Tea)
INSERT INTO recipe_main 
(recipe_id, rec_title, category_id, recipe_desc, prep_time, cook_time, servings, difficulty, directions) 
VALUES 
(3, 'Masala Chai', 3, 'Traditional Indian spiced tea with aromatic spices', 5, 10, 4, 1, 
'Crush ginger, cardamom, cinnamon, peppercorns, and cloves using a mortar and pestle. In a saucepan, bring water to a boil. Add the crushed spices and let them simmer for 2-3 minutes to release their flavors. Add black tea leaves and let it boil for another 2 minutes. Add milk and sugar to taste. Bring the mixture to a boil again, then reduce heat and simmer for 3-4 minutes, stirring occasionally. Strain the chai through a fine mesh strainer into cups. Serve hot and enjoy the aromatic flavors!');

-- Recipe 4: Aloo Paratha (Potato Stuffed Flatbread)
INSERT INTO recipe_main 
(recipe_id, rec_title, category_id, recipe_desc, prep_time, cook_time, servings, difficulty, directions) 
VALUES 
(4, 'Aloo Paratha', 4, 'Popular Indian flatbread stuffed with spiced mashed potatoes', 20, 20, 4, 2, 
'Boil potatoes until tender, peel and mash them well. Add finely chopped onion, green chili, coriander leaves, cumin seeds, garam masala, and salt to the mashed potatoes. Mix well to make the filling. In a bowl, mix whole wheat flour with salt and water to make a soft dough. Let it rest for 15 minutes. Divide dough into equal portions and roll into small circles. Place potato filling in the center of each circle. Bring the edges together and seal. Roll gently into a flat circle. Heat a griddle or tawa over medium heat. Cook the paratha on both sides, applying butter or oil, until golden brown spots appear. Serve hot with yogurt, pickle, or butter.');

-- =======================================================
--  INSERTING NEW INGREDIENTS INTO ingredients table
-- =====================================================

INSERT INTO ingredients (ingredient_id, ingred_name) VALUES
(20, 'Water'),
(21, 'Black tea leaves'),
(22, 'Milk, whole'),
(23, 'Ginger, fresh'),
(24, 'Cardamom pods'),
(25, 'Cinnamon stick'),
(26, 'Black peppercorns'),
(27, 'Cloves, whole'),
(28, 'Whole wheat flour'),
(29, 'Potatoes, boiled'),
(30, 'Onion, chopped'),
(31, 'Green chili, chopped'),
(32, 'Coriander leaves, fresh'),
(33, 'Cumin seeds'),
(34, 'Garam masala'),
(35, 'Vegetable oil');

-- =====================================================
-- Linking RECIPES To INGREDIENTS (rec_ingredients)
-- =====================================================

-- Masala Chai ingredients (recipe_id = 3)
INSERT INTO rec_ingredients (recipe_id, amount, ingredient_id) VALUES
(3, 2.00, 20),   -- 2 cups water
(3, 1.00, 21),   -- 1 tbsp black tea leaves
(3, 1.00, 22),   -- 1 cup milk
(3, 2.00, 11),   -- 2 tbsp sugar (reusing existing white sugar)
(3, 1.00, 23),   -- 1 inch ginger
(3, 4.00, 24),   -- 4 cardamom pods
(3, 1.00, 25),   -- 1 cinnamon stick
(3, 4.00, 26),   -- 4 black peppercorns
(3, 2.00, 27);   -- 2 cloves

-- Aloo Paratha ingredients (recipe_id = 4)
INSERT INTO rec_ingredients (recipe_id, amount, ingredient_id) VALUES
(4, 2.00, 28),   -- 2 cups whole wheat flour
(4, 3.00, 29),   -- 3 large potatoes
(4, 1.00, 30),   -- 1 onion
(4, 2.00, 31),   -- 2 green chilies
(4, 0.25, 32),   -- 1/4 cup coriander leaves
(4, 1.00, 33),   -- 1 tsp cumin seeds
(4, 0.50, 34),   -- 1/2 tsp garam masala
(4, 1.00, 15),   -- 1 tsp salt (reusing existing)
(4, 3.00, 35),   -- 3 tbsp oil
(4, 2.00, 5);    -- 2 tbsp butter (reusing existing)

-- =====================================================
-- Checking if data inserted correctly or not
-- =====================================================

-- Check categories
SELECT * FROM categories;

-- Check new recipes
SELECT * FROM recipe_main WHERE recipe_id IN (3, 4);

-- Check new ingredients
SELECT * FROM ingredients WHERE ingredient_id >= 20;

-- Check recipe-ingredient links
SELECT * FROM rec_ingredients WHERE recipe_id IN (3, 4);




-- =====================================================
-- QUESTION 2: ONE QUERY TO RETURN ALL INFORMATION
-- Returns all info from all 4 tables for ONLY the two new recipes
-- =====================================================

SELECT 
    rm.recipe_id,
    rm.rec_title,
    rm.recipe_desc,
    rm.prep_time,
    rm.cook_time,
    rm.servings,
    rm.difficulty,
    rm.directions,
    c.category_id,
    c.category_name,
    i.ingredient_id,
    i.ingred_name,
    ri.rec_ingredient_id,
    ri.amount
FROM recipe_main rm
JOIN categories c ON rm.category_id = c.category_id
JOIN rec_ingredients ri ON rm.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE rm.recipe_id IN (3, 4)
ORDER BY rm.recipe_id, i.ingred_name;





-- =====================================================
-- QUESTION 3: SPECIFIC SELECT QUERY WITH SORTING
-- Shows: recipe name, category name, ingredient name, amount
-- Sorted: category DESC, recipe name ASC, ingredient name DESC
-- =====================================================

SELECT 
    rm.rec_title AS recipe_name,
    c.category_name,
    i.ingred_name AS ingredient_name,
    ri.amount AS ingredient_amount
FROM recipe_main rm
JOIN categories c ON rm.category_id = c.category_id
JOIN rec_ingredients ri ON rm.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE rm.recipe_id IN (3, 4)
ORDER BY c.category_name DESC, rm.rec_title ASC, i.ingred_name DESC;