/* 

Objective of program: 
To perform descriptive and exploratory analysis of the 2015 World Happiness dataset by examining GDP category distributions, 
summarising key study variables, comparing Happiness Scores between GDP categories, and analysing the relationships 
between Happiness Score and the selected explanatory variables using correlation analysis and scatterplots.

*/ 

/* 1. Import the cleaned dataset */

/* Import the cleaned Happiness 2015 dataset into SAS for descriptive analysis */

proc import 
    datafile="/home/u64347364/STAT2044-ASM-NEW/Dataset_CLEAN/Happiness_Final_Cleaned.csv"
    out=happiness
    dbms=csv
    replace;
    guessingrows=max;

run;

/* =========================================================
   2. Frequency Analysis of GDP Category
   ========================================================= */

/* Generate frequency counts and percentages for each GDP category */

proc freq data=happiness noprint;
    tables GDP_Category / out=gdp_freq;
run;

/* Create a formatted label combining the frequency and percentage */

data gdp_freq;
    set gdp_freq;

    Label = cats(
        put(COUNT, 3.),
        " (",
        put(PERCENT, 5.1),
        "%)"
    );

run;

/* Display the GDP category frequency summary */

proc print data=gdp_freq;

    title "GDP Category Frequency Summary";

run;

/* Create a bar chart to display the distribution of countries
   according to GDP category */
  
proc sgplot data=gdp_freq;

    vbar GDP_Category /
        response=COUNT
        datalabel=Label
        datalabelattrs=(size=10 weight=bold)
        barwidth=0.35;

    title height=14pt
          "Distribution of Countries by GDP Category";

    xaxis label="GDP Category"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10);

    yaxis label="Frequency of Countries"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10)
          grid;

run;

/* =========================================================
   3. Descriptive Statistics
   ========================================================= */

/* Calculate the number of observations, mean, median,
   standard deviation, minimum and maximum for the main
   continuous study variables */

proc means data=happiness 
           n mean median std min max maxdec=2;

    var Happiness_Score
        GDP_per_Capita
        Family
        Life_Expectancy
        Freedom
        Government_Trust
        Generosity;

    title "Summary Statistics of Study Variables";

run;

/* Create a histogram of Happiness Score with a normal
   density curve to examine its distribution */

proc sgplot data=happiness;

    histogram Happiness_Score /
        scale=count
        transparency=0.2;

    density Happiness_Score /
        type=normal;

    title height=14pt
          "Distribution of Happiness Score";

    xaxis label="Happiness Score"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10);

    yaxis label="Frequency"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10)
          grid;

run;

/* =========================================================
   4. GDP Group Comparison
   ========================================================= */

/* Calculate descriptive statistics for Happiness Score
   separately for each GDP category */

proc means data=happiness 
           n mean median q1 q3 std min max maxdec=2;

    class GDP_Category;

    var Happiness_Score;

    title "Summary Statistics of Happiness Score by GDP Category";

run;

/* Create a boxplot to compare the distribution of Happiness
   Score between the two GDP categories */

proc sgplot data=happiness;

    vbox Happiness_Score /
        category=GDP_Category
        fillattrs=(transparency=0.3)
        lineattrs=(thickness=2)
        meanattrs=(symbol=diamond size=8);

    title height=14pt
          "Distribution of Happiness Score by GDP Category";

    xaxis label="GDP Category"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10);

    yaxis label="Happiness Score"
          labelattrs=(size=11 weight=bold)
          valueattrs=(size=10)
          grid;

run;

/* =========================================================
   5. Relationship Analysis
   ========================================================= */

/* Calculate Pearson correlation coefficients between
   Happiness Score and the selected explanatory variables */

proc corr data=happiness 
          noprob 
          nosimple 
          outp=corr_result;

    var Happiness_Score
        GDP_per_Capita
        Family
        Life_Expectancy
        Freedom
        Government_Trust
        Generosity;

run;

/* Extract the correlation between Happiness Score and
   each explanatory variable */

data correlation_table;

    length Variable $30;

    set corr_result;

    if _NAME_ = "Happiness_Score";

    Variable = "GDP per Capita";
    Correlation = GDP_per_Capita;
    output;

    Variable = "Family";
    Correlation = Family;
    output;

    Variable = "Life Expectancy";
    Correlation = Life_Expectancy;
    output;

    Variable = "Freedom";
    Correlation = Freedom;
    output;

    Variable = "Government Trust";
    Correlation = Government_Trust;
    output;

    Variable = "Generosity";
    Correlation = Generosity;
    output;

    keep Variable Correlation;

run;

/* Display the Pearson correlation results in a clear
   table for interpretation and reporting */

proc report data=correlation_table nowd;

    column Variable Correlation;

    define Variable /
        "Explanatory Variable"
        width=35
        flow;

    define Correlation /
        "Correlation with Happiness Score"
        width=20
        format=8.3;

    title "Pearson Correlation Between Happiness Score and Explanatory Variables";

run;

/* Restructure the explanatory variables into a long format
   so that they can be displayed together in the scatterplots */

data happiness_long;

    length Predictor $30;

    set happiness;

    Predictor = "GDP per Capita";
    Value = GDP_per_Capita;
    output;

    Predictor = "Family";
    Value = Family;
    output;

    Predictor = "Life Expectancy";
    Value = Life_Expectancy;
    output;

    Predictor = "Freedom";
    Value = Freedom;
    output;

    Predictor = "Government Trust";
    Value = Government_Trust;
    output;

    Predictor = "Generosity";
    Value = Generosity;
    output;

    keep Happiness_Score Predictor Value;

run;

/* Create scatterplots with fitted regression lines to
   visualise the relationships between Happiness Score
   and each explanatory variable */

proc sgpanel data=happiness_long;

    panelby Predictor /
        columns=3
        rows=2
        novarname;

    scatter x=Value
            y=Happiness_Score;

    reg x=Value
        y=Happiness_Score;

    colaxis label="Explanatory Variable";

    rowaxis label="Happiness Score";

    title "Scatterplot Relationships Between Happiness Score and Explanatory Variables";

run;

/* END */
