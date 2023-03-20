
# Evaluating different methods for estimate kin availability by sex

<!-- badges: start -->
<!-- badges: end -->

The goal of this short exercise is to apply different ways of estimating kin availability by sex.

## Estimating kin availability using the GKP model

In Family Demography, there is a recognized method that uses the formal relationship in a stable population to estimate the availability of ascending or descending relatives that a focal person has in some time (GOODMAN; KEYFITZ; PULLUM, 1974). For estimating the different relationships with a focal person, we need to assume some assumptions for the classic GKP model that, on some occasions, makes this method difficult to be used.

Recently, Hall Caswell and colleagues have published a series of papers that intend to discuss some possibilities to deal with the rigid assumptions of the classic GKP model (CASWELL, 2019, 2020, 2022; CASWELL; SONG, 2021). The main goal of this application is to discuss empirically using the latest Caswell publication in that he discusses the different approximations to deal with the assumption of the one-sex  GKP model.


## Two-sex models and their approximations

As Caswell (2022) proposed, when it is available data for (i) male fertility by age; (ii) female fertility by age; (iii) male mortality by age; and (iv) female mortality by age, we can estimate the availability of kin that a focal person (male or female) would have, submitted for this demographic regime.

On other hand, when there is no availability of male fertility and/or mortality data, Caswell also argued that there are some approximations that it is possible to be used and reaches good results:

- **Androgynous**: this approximation assumes equal fertility and mortality for males and females.

- **GKP factors**: this approximation duplicates the number of each type of relative (e.g., mothers is multiplied by two...).

## Comparing Two-sex estimates with different approximations

Fortunately, there is an excellent R package that is possible to apply the GKP model and its recent variations: [DemoKin](https://github.com/IvanWilli/DemoKin) (WILLIAMS, et al., 2021).

In a recent [vignette of the DemoKin package](https://github.com/IvanWilli/DemoKin/blob/main/vignettes/Reference_TwoSex.Rmd), the authors propose an empirical evaluation for the accuracy of the two-sex estimates. Their evaluated three different estimates: (i) Full Data estimates, using fertility and mortality rates for each sex; (ii) Androgynous estimates, using fertility and mortality rates for the female sex and assuming it's for the male sex; and (iii) GKP factor estimates, using GKP factors, as explained above.

The results pointed to good accuracy when it was used both approximations, except for the Grandparents, and Great-grandparents.

Bellow, I propose a little adaptation of the **androgynous** approximation to approximate the reality of the data available in most countries, when it is available mortality rates for each sex, but it is not available for confident male fertility rates.

In this situation, we can use the *female fertility rates*, assuming that this pattern and level will be repeated for the male population[^1].

[^1]: In fact, we know that the pattern and the level are not the same between the sex. But, in the context that we don't have this data, it can be an assumption, as Caswell (2022) proposed.

## Empirical evaluation of the 'Alternative' approximation for Two-sex estimates

Below, we can see the number of selected kin that a female person would be in your life, case she was submitted for the French demographic rates.

<p align="center" width="80%">
    <img width="80%" src="https://github.com/thiagocalm/DemoKin_two_sex/blob/master/output/comparing_number_of_kin_by_methods.jpeg">
</p>

Comparing the estimates, it is possible to see that there are differences among the type of relationship that is estimated. For the first ascending relatives (parents and aunt/uncle) or first descending relatives (children) the focal person, there is a good estimate for all of the approximations. Still, there is a better adjustment of the 'Alternative' estimates than 'GKP factors' independent of the type of relative.

<p align="center" width="80%">
    <img width="80%" src="https://github.com/thiagocalm/DemoKin_two_sex/blob/master/output/ration_between_methods.jpeg">
</p>

To analyze what was the difference between Alternative and GKP approximations, comparing with the 'true' scenario (using data for each sex), we can use the ratio between each approximation and the reference scenario (graphic above). It is possible to see that deviance from the true scenario tends to happen with the same intensity for both methods for the grandparents and great-grandparents. Differently, the intensity that the deviation occurs for the first generation of the ascending relatives is greater for 'GKP factors' than the 'Alternative' approximation method.

Another possibility to compare the estimates is through the number of kin by type and sex along the female age focal (graphic below). The left side represents the number of kin by sex and methods. The right side represents the ratio between the Alternative method and the 'true' estimate, by sex and type of relative.

<p align="center" width="80%">
    <img width="80%" src="https://github.com/thiagocalm/DemoKin_two_sex/blob/master/output/comparing_alternative_full_by_sex.jpeg">
</p>


Although the visual evaluation is difficult in this case, we can see that the number of male relatives is different depending on the method, mainly in the case of great-grandparents and grandparents. When we compare the deviation of the estimates by sex, we can see interesting relations. If the difference between the Alternative approximation and the 'true' estimates is the same for both sex, it is evidence that, probably, the difference of the input for estimation affects the relative's estimation because of the interactive process underlying the GKP model. It is the case of the Aunt/Uncle relatives. On the other hand, in the case of the male estimates deviation being greater than the female estimates, it would be evidence that there is a direct effect of the different rates that are used by *input*. It is the case for almost all other relatives.

## To conclude...

It is possible to say that this exercise indicates for:

1. There is a good estimate when it is used approximations, but the results are better for the approximations that use different rates for males and females.

2. The more distant the degree of kinship, in terms of generations, there is a tendency for worse results from the approximations.

3. There is a sex difference in the estimation results that point to a *direct effect* and an *indirect effect* of the different inputs used in the approximations.

## References

Caswell, H. 2019. The formal demography of kinship: A matrix formulation. Demographic Research 41:679–712. doi:10.4054/DemRes.2019.41.24.

Caswell, H. 2020. The formal demography of kinship II: Multistate models, parity, and sibship. Demographic Research 42: 1097-1144. doi:10.4054/DemRes.2020.42.38.

Caswell, Hal and Xi Song. 2021. “The Formal Demography of Kinship. III. Kinship Dynamics with Time-Varying Demographic Rates.” Demographic Research 45: 517–46. doi:10.4054/DemRes.2021.45.16.

Caswell, H. (2022). The formal demography of kinship IV: Two-sex models and their approximations. Demographic Research, 47, 359–396.

Goodman, L.A., Keyfitz, N., and Pullum, T.W. (1974). Family formation and the frequency of various kinship relationships. Theoretical Population Biology 5(1):1–27. doi:10.1016/0040-5809(74)90049-5.

Williams, Iván; Alburez-Gutierrez, Diego; Song, Xi; and Hal Caswell. (2021) DemoKin: An R package to implement demographic matrix kinship models. URL: https://github.com/IvanWilli/DemoKin.


