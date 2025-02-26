The SPA.Algorithm.Demo application illustrates the SPA algorithm by implementing a version of it and allowing users to interact with it.

Table of contents of this page:
- [Logic of the SPA.Algorithm.Demo application](#logic-of-the-spaalgorithmdemo-application)
- [Interacting with the SPA.Algorithm.Demo application](#interacting-with-the-spaalgorithmdemo-application)
- [Data sets compiled by domain experts](#data-sets-compiled-by-domain-experts)
- [Computation of adequacy scores and ranking](#computation-of-adequacy-scores-and-ranking)
- [Source code and licences](#source-code-and-licences)

### Logic of the SPA.Algorithm.Demo application

The application proposes a *list of public-heath surveillance approaches* ranked according to their adequacy given three criteria: *country context*, *diseases* of interests, and desired *features and objectives* of surveillance.

For each approach, a *Score* between 0 and 1 measures the adequacy and is the basis for the ranking. It is derived from scores computed for each of the three criteria. The overall logic is (see the section [Computation of adequacy scores and ranking](#computation-of-adequacy-scores-and-ranking) below for a technical description):
- the higher the *Score*, the more adequate the approach;
- a *Score* of 0 means that an approach is not suitable given the criteria;
- when multiple diseases or multiple features / objectives are selected, if an approach is adequate for any combination of single disease and single feature / objective, then it is considered overall adequate to some extend, similar to a "OR" logic of the adequacy for different combinations diseases and features / objectives;
- the adequacy of an approach for a single combination of country, disease, and feature / objective, is measured by the *CDO Score* (Country Disease Objectives), between 0 and 1;
- the country, disease, and feature / objective, may have different weights one compared to the other, all other things equal, in determining the overall adequacy of a surveillance approach; 
- given a disease and given a feature / objective, if an approach is inadequate for any of them, then it considered inadequate overall, similar to a "AND" logic of the adequacy for a disease and a feature / objective;
- the adequacy for a disease is measured by a *Disease Score*, which is either 0 (inadequate) or 1 (adequate), based on expert assessment matching diseases and surveillance approaches;
- the adequacy for a feature / objective is measured by a *Objective Score*, between 0 and 1, based on expert assessment matching surveillance features or objectives and surveillance approaches; 
- while an approach can be excluded based on a disease or feature / objective, it can't be excluded based on country context; 
- the adequacy for country context is measured by the *Country Score*, between 0.5 and 1, which in turns depends on four properties of the country: whether it tends to be affected by natural disasters, whether it tends to have disease outbreaks, its laboratory capacity, and its disease-surveillance capacity;
- these properties are measured based on publicly available country data;
- if an approach is adequate with respect to any of the four properties, then it is considered adequate to some extend with respect to country context, similar to a "OR" logic.

### Interacting with the SPA.Algorithm.Demo application

The application contains two panels: the side panel to the left and the main panel to the right. 

In the *side panel*, a single *country* can be chosen from the drop down menu, multiple *diseases* and *features / objectives* can be chosen from the respective fields, among pre-selected options. When can start and type in each field to narrow the options proposed.

When the page is loaded or re-loaded, all previous settings and criteria are discarded, and a new random set of criteria is selected.

The *main panel* contains four tabs: Optimal approaches, Results, Advanced controls, Data, About.

The tab *Optimal approaches* shows a list of surveillance approaches that rank above the *Score threshold* (see below), in order of adequacy.

The tab *Results* shows the detailed results of computations, i.e. the individual scores, computed as described in the section [Computation of adequacy scores and ranking](#computation-of-adequacy-scores-and-ranking) below, for each surveillance approach, for the country selected, for each one of the diseases selected, and for each one of the features / objectives selected. If a surveillance approach has an overall *Score* above the *Score threshold* (by default 0.75), then it is displayed in the "Optimal approaches" tab, in decreasing order of the *Score* as measured by *Rank*. The table can be sorted according to any column, and it can be filtered via the search bar. Approaches with an overall *Score* of 0, i.e. those that are deemed not at all adequate, are not shown.

The tab *Advanced controls* shows two sets of controllers for advanced users:
- the *Score threshold*, a number between 0 and 1, above which a surveillance approach should be displayed in the "Optimal approaches" tab;
- the *weights* to give to the three types of criteria (country, diseases, features / objectives), i.e. whether one should have more influence on the final ranking, see the section [Computation of adequacy scores and ranking](#computation-of-adequacy-scores-and-ranking) below for a technical description; the weights are positive numbers and only their relative values matter matter for the outcome.

The tab *Data* allows users to access the data used in the application. Under the sub-tab *Download* one can get a zipped file of the data sets in their original format (Excel files), the other sub-tabs display the same data in the application itself in a dynamic way, all tables can be sorted according to any column, and it can be filtered via the search bar. The individual datasets are explained in detail below.

The tab *About* is describes the application.

### Data sets compiled by domain experts

The data necessary to match surveillance approaches to the relevant criteria (country, diseases, features / objectives).

The *Country context* is defined by a set of indicators and by rules to identify prioritised surveillance approaches based on those indicators. The country is relevant from an operational and administrative point of view. Each country has a unique context that influences the relevance of different surveillance approaches. Currently, this context is reduced to four main aspects: whether a country is prone to natural disasters, to epidemics, as well as its laboratory and disease surveillance capacities. These four aspects are measured by four publicly available indicators: 
- Natural disaster risk: [INFORM's composite score for national risk of any type of natural disaster](https://drmkc.jrc.ec.europa.eu/inform-index)
- Epidemic risk: [INFORM's score national for risk of epidemics](https://drmkc.jrc.ec.europa.eu/inform-index)
- Laboratory Capacity D1.1: [WHO's scores national laboratory capacity and pathogen testing capabilities](https://extranet.who.int/sph/jee/activities?items_per_page=200&search=&field_region_target_id=All&field_country_target_id=All&field_province_target_id=All&field_jee_tax_status_target_id=All&field_document_availability_value=All)
- Surveillance Capacity D2.1: [WHO's scores national surveillance system capacity](https://extranet.who.int/sph/jee/activities?items_per_page=200&search=&field_region_target_id=All&field_country_target_id=All&field_province_target_id=All&field_jee_tax_status_target_id=All&field_document_availability_value=All)

The rules, established by disease surveillance experts, consists in thresholds above or below which certain surveillance approaches are prioritised.

*Disease matching* is a matrix of diseases vs surveillance approaches, with 1 if a surveillance approach is adequate for a given disease, and 0 else. It was compiled by disease surveillance experts.

*Feature / objective matching* is a matrix of surveillance approaches vs surveillance-system features or surveillance objectives. It measures with a number, 0, 1, 2, or 3, how much a certain approach displays a certain feature or is adequate for a certain objective. It represents a consensus among multiple disease surveillance experts.

### Computation of adequacy scores and ranking

This section describes the steps by which the overall *Score*, which measures the adequacy of each surveillance approach given the criteria defined, is derived from the country context, the disease vs surveillance approach matching, and the surveillance approach vs feature / objective matching.

N.B. For better readability, all numbers in the tables under "Results" and "Data" are displayed rounded to two digits.

The first step consists in transforming each data source a matching of a surveillance approach vs a criterium. Each matching is measured by a specific score, between 0 and 1:
- Country context: for each of the four indicators, a score for a given surveillance approach and a given country is 1 if the indicator meets one of the **inclusion rules** and the approach is then prioritised, otherwise it is 0.5:
  - *Disaster Score* (for Natural disaster risk indicator) = 0.5 or 1;
  - *Epidemic Score* (for Epidemic risk indicator)  = 0.5 or 1;
  - *Lab Score* (for Laboratory Capacity D1.1 indicator)  = 0.5 or 1;
  - *Surveillance Score* (for indicator Surveillance Capacity D2.1) = 0.5 or 1.
- Diseases: the score *Disease Score* is the same number (0 or 1) in **disease matching** table;
- Features / objectives: the score *Objective Score* is the number (0, 1, 2, or 3) in the raw **feature / objective matching** table divided by 3, so that it is between 0 and 1 (it can thus take the values 0, 0.33, 0.67, or 1, approximately).

The minimum of each context score is set to 0.5 and cannot be changed within the application. The value of 0.5 has no specific meaning and could be set differently while keeping the overall logic. This value reflects to some extend, being the middle between 0 and 1, the fact that the country context never excludes approaches in itself, but rather might warrant prioritising certain approaches. It also down-plays (at constant weights, see below) variations across surveillance approaches in regard of country context compared to variations in regard of disease or feature / objective.

The second step consists in deriving a single score from the four country-context ones:
- Country context: *Country Score* is the **average** of the four scores: *Country Score* = (*Disaster Score* + *Epidemic Score* + *Lab Score* + *Surveillance Score*) / 4

The third step combines the three scores for one country, one disease and one feature and objective, into one score, called *CDO Score* (Country Disease Objectives). The logic stipulates that:
- if an approach is excluded based on disease or feature / objective, i.e. if *Disease Score* = 0 or *Score feature/objective* = 0, then the approach should be excluded, i.e. *CDO Score* = 0;
- an approach shouldn't be excluded based on context only (note that given that a minimum above 0 (currently 0.5) is set for each context score, then *Country Score* is always strictly positive);
- one expects that if a given approach is optimal in all three respects, i.e. if *Country Score* = *Disease Score* = *Score feature/objective* = 1, then the approach should be considered optimal for their combination, i.e. *CDO Score* = 1; 
- lastly, one would like to have the possibility of weighing country context, disease, and feature/objective differently, i.e. to give more importance to one or the other criterium compared to the others.

All these conditions can be met by using a **multiplicative formula** and defining:
- *CDO Score* as the [weighted geometric mean](https://en.wikipedia.org/wiki/Weighted_geometric_mean) of *Country Score*, *Disease Score*, and *Score feature/objective*:
  - *CDO Score* = (*Country Score* ^ *wc* * *Disease Score* ^ *wd* * *Score feature/objective* ^ *wo*) ^ (1/(*wc* + *wd* + *wo*)),
  - where *wc*, *wd*, *wo* are the weights of country context, disease, and feature/objective, respectively;
- when, as by default, all weights are equal, then *CDO Score* becomes the [geometric mean](https://en.wikipedia.org/wiki/Geometric_mean) of *Country Score*, *Disease Score*, and *Score feature/objective*:
  - *CDO Score* = (*Country Score* * *Disease Score* * *Score feature/objective*) ^ (1/3) 

The fourth step brings the different combinations of country, diseases and features / objectives. The *CDO Score* is defined for one surveillance and a single combination of one country, one disease, and one feature/objective. However we want to allow for multiple diseases and multiple features or objectives, and choose to define: 
- the final, overall ***Score* as the average of all *CDO Scores* over all combinations of one disease and one feature/objective** among those selected as criteria in the left panel; 
- this ensures that even if an approach is excluded for a given disease or feature / objective but not for others, it will still be considered as relevant for the overall criteria, albeit with a reduced adequacy.

Lastly, the approaches are ranked according to their overall *Score*. This *Rank* determines the order in which they are displayed, in case of a tie, they are shown in alphabetical order. Only those approaches above the *Score threshold* defined in the tab "Advanced control" are displayed in the tab "Optimal approaches. This threshold is by default set to 0.75, this specific number has no particular meaning.

### Source code and licences

See [https://github.com/stephaneghozzi/SPA.Algorithm.Demo](https://github.com/stephaneghozzi/SPA.Algorithm.Demo).
