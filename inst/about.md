This a demo application illustrating the SPA algorithm.

Code repository: [https://github.com/stephaneghozzi/SPA.Algorithm.Demo](https://github.com/stephaneghozzi/SPA.Algorithm.Demo)

### Logic

The application proposes a *list of public-heath surveillance approaches* ranked according to their adequacy given three criteria: *country context*, *diseases* of interests, and desired *features and objectives* of surveillance.

For each approach, a *Score* between 0 and 1 measures the adequacy and is the basis for the ranking. It is derived from scores computed for each of the three criteria. The overall logic is (see technical description below):
- the higher the *Score*, the more adequate the approach;
- a *Score* of 0 means that an approach is not suitable given the criteria;
- when multiple diseases or multiple features / objectives are selected, if an approach is adequate for any combination of single disease and single feature / objective, then it is considered overall adequate to some extend, similar to a "OR" logic of the adequacies for different combinations diseases and features / objectives;
- given a disease and given a feature / objective, if an approach is inadequate for any of them, then it considered inadequate overall, similar to a "AND" logic of the adequacies for a disease and a feature / objective;
- the adequacy for a disease is measured by a *Score disease*, which is either 0 (inadequate) or 1 (adequate), based on expert assessment matching diseases and surveillance approaches;
- the adequacy for a feature / objective is measured by a *Score feature / objective*, between 0 and 1, based on expert assessment matching surveillance features or objectives and surveillance approaches; 
- while an approach can be excluded based on a disease or feature / objective, it can't be excluded based on country context; 
- the adequacy for country context is measured by the *Score country*, between 0.5 and 1, which in turns depends on four properties of the country: whether it tends to be affected by natural disasters, whether it tends to have disease outbreaks, its laboratory capacity, and its disease-surveillance capacity;
- these properties are measured based on publicly available country data;
- if an approach is adequate with respect to any of the four properties, then it is considered adequate to some extend with respect to country context, similar to a "OR" logic.

### Interacting with the application

[to be added]

### Data sets

[to be added]

### Computation of scores

[to be added]
