import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation/models/meal.dart';
import 'package:navigation/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterNotifire extends StateNotifier<Map<Filter, bool>> {
  FilterNotifire()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifire, Map<Filter, bool>>((ref) {
  return FilterNotifire();
});

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filterProvider);

  return meals.where((meal) {
    if (!meal.isGlutenFree && activeFilters[Filter.glutenFree]!) {
      return false;
    }
    if (!meal.isLactoseFree && activeFilters[Filter.lactoseFree]!) {
      return false;
    }
    if (!meal.isVegan && activeFilters[Filter.vegan]!) {
      return false;
    }
    if (!meal.isVegetarian && activeFilters[Filter.vegetarian]!) {
      return false;
    }
    return true;
  }).toList();
});
