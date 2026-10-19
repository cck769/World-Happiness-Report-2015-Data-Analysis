/* 

Creator: Liew Ke Yin
Student ID: 24043010
Objective of program: To perform an independent samples t-test to determine whether there is a significant difference in the 
mean Happiness Score between countries with above-average and below-average GDP per Capita using the 2015 World Happiness dataset.

*/

/* =========================================================
   1. Import the cleaned dataset
   ========================================================= */

/* Import the cleaned 2015 World Happiness dataset into SAS */

proc import 
    datafile="/home/u64347364/STAT2044-ASM-NEW/Dataset_CLEAN/Happiness_Final_Cleaned.csv"
    out=happiness
    dbms=csv
    replace;

    guessingrows=max;

run;

/* =========================================================
   2. Calculate Mean GDP per Capita
   ========================================================= */

/* Calculate the overall mean GDP per Capita.
   This value is used as the cut-off point to classify
   countries into above-average and below-average GDP groups. */

proc sql noprint;

    select mean(GDP_per_Capita)
    into :Mean_GDP
    from happiness;

quit;

/* Display the calculated mean GDP per Capita in the SAS log */

%put Overall Mean GDP per Capita = &Mean_GDP;

/* =========================================================
   3. Create GDP Categories
   ========================================================= */

/* Classify countries into above-average and below-average
   GDP groups based on the overall mean GDP per Capita. */

data Happiness_Grouped;

    set happiness;

    length GDP_Group $20;

    if GDP_per_Capita >= &Mean_GDP then
        GDP_Group = "Above Average";

    else if GDP_per_Capita < &Mean_GDP then
        GDP_Group = "Below Average";

run;

/* =========================================================
   4. Frequency Analysis of GDP Groups
   ========================================================= */

/* Calculate the number and percentage of countries
   in each GDP category. */

proc freq data=Happiness_Grouped;

    tables GDP_Group;

    title "Frequency Distribution of GDP Groups";

run;

/* =========================================================
   5. Descriptive Statistics by GDP Group
   ========================================================= */

/* Calculate descriptive statistics for Happiness Score
   separately for the two GDP groups. */

proc means data=Happiness_Grouped
           n mean median std min max maxdec=4;

    class GDP_Group;

    var Happiness_Score;

    title "Descriptive Statistics of Happiness Score by GDP Group";

run;

/* =========================================================
   6. Boxplot of Happiness Score by GDP Group
   ========================================================= */

/* Create a boxplot to compare the distribution of
   Happiness Score between the two GDP groups. */

proc sgplot data=Happiness_Grouped;

    vbox Happiness_Score / category=GDP_Group;

    xaxis label="GDP Group";

    yaxis label="Happiness Score";

    title "Distribution of Happiness Score by GDP Group";

run;

/* =========================================================
   7. Normality Assessment
   ========================================================= */

/* Assess the normality of Happiness Score within each
   GDP group using histograms and normal Q-Q plots. */

proc univariate data=Happiness_Grouped normal;

    class GDP_Group;

    var Happiness_Score;

    histogram Happiness_Score / normal;

    qqplot Happiness_Score /
           normal(mu=est sigma=est);

    title "Normality Assessment of Happiness Score by GDP Group";

run;

/* =========================================================
   8. Independent Samples T-Test
   ========================================================= */

/* Perform an independent samples t-test to determine
   whether the mean Happiness Score differs significantly
   between the above-average and below-average GDP groups. */

ods graphics on;

proc ttest data=Happiness_Grouped
           alpha=0.05
           plots=all;

    class GDP_Group;

    var Happiness_Score;

    title "Independent Samples T-Test for Happiness Score by GDP Group";

run;

ods graphics off;

/* END */
