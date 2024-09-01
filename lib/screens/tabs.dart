import 'package:flutter/material.dart';
import 'package:navigation/data/dummy_data.dart';
import 'package:navigation/models/meal.dart';
import 'package:navigation/screens/categories.dart';
import 'package:navigation/screens/filters.dart';
import 'package:navigation/screens/meals.dart';
import 'package:navigation/widgets/main_drawer.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _selectedFilter = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false,
  };

  void _updateFilters(Map<Filter, bool> filters) {
    setState(() {
      _selectedFilter = filters;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifire) {
    Navigator.of(context).pop();
    if (identifire == 'filters') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilter: _selectedFilter,
            onChangedFilter: _updateFilters,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availabelMeals = dummyMeals.where((meal) {
      if (!meal.isGlutenFree && _selectedFilter[Filter.glutenFree]!) {
        return false;
      }
      if (!meal.isLactoseFree && _selectedFilter[Filter.lactoseFree]!) {
        return false;
      }
      if (!meal.isVegan && _selectedFilter[Filter.vegan]!) {
        return false;
      }
      if (!meal.isVegetarian && _selectedFilter[Filter.vegetarian]!) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      availabelMeals: availabelMeals,
      onToggleFavoriteMeal: _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavoriteMeal: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
