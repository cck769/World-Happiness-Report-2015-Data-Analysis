/* 

Creator: Cheah Choon Keat 
Student ID: 24104184 
Objective of program: 
To clean and prepare the World Happiness Report 2015 dataset by checking data quality, removing duplicate observations, 
assessing variable normality, creating GDP categories for the t-test, and exporting the final cleaned dataset for statistical analysis.

*/ 

/* 1. Setup library & import raw datafile */
/* Assign a library reference to the folder containing the datasets */
libname mylib '/home/u64347364/STAT2044-ASM-NEW/Dataset_CLEAN';
  data mylib.happiness2015;

    /* Point to the raw data file */
    infile '/home/u64347364/STAT2044-ASM-NEW/Dataset_RAW/happiness_2015.csv'
        dlm = ','
        dsd
        missover
        firstobs = 2;


    /* 2. Define variable formats */

    informat Country $30.;
    informat Region $30.;
    informat Happiness_Rank 8.;
    informat Happiness_Score 8.;
    informat Standard_Error 8.;
    informat GDP_per_Capita 8.;
    informat Family 8.;
    informat Life_Expectancy 8.;
    informat Freedom 8.;
    informat Government_Trust 8.;
    informat Generosity 8.;
    informat Dystopia_Residual 8.;


    /* Define how SAS displays character variables */

    format Country $30.;
    format Region $30.;


    /* 3. Read in the variables */

    input 
        Country $
        Region $
        Happiness_Rank
        Happiness_Score
        Standard_Error
        GDP_per_Capita
        Family
        Life_Expectancy
        Freedom
        Government_Trust
        Generosity
        Dystopia_Residual;

run;


/* =========================================================
   4. DATA QUALITY CHECKS
   ========================================================= */


/* Check numeric variables for missing values,
   minimum and maximum values */

proc means data=mylib.happiness2015
           n nmiss min max mean median std;

    var Happiness_Rank
        Happiness_Score
        Standard_Error
        GDP_per_Capita
        Family
        Life_Expectancy
        Freedom
        Government_Trust
        Generosity
        Dystopia_Residual;

run;


/* Check character variables for missing values */

proc freq data=mylib.happiness2015;

    tables Country Region / missing;

run;

/* =========================================================
   5. DUPLICATE CHECKING AND REMOVAL
   ========================================================= */

/* Remove exact duplicate observations */

proc sort data=mylib.happiness2015
          out=mylib.happiness_Cleaned
          nodupkey
          dupout=mylib.happiness_Duplicates;

    by _all_;

run;


/* Check the cleaned dataset structure */

proc contents data=mylib.happiness_Cleaned;

run;


/* Display cleaned dataset */

title "Happiness_Cleaned_Dataset";
proc print data=mylib.happiness_Cleaned;

run;


/* Check whether duplicate observations were found */

proc print data=mylib.happiness_Duplicates;

run;

title "Normality Tests for Happiness 2015 Variables";
proc univariate data=mylib.happiness_Cleaned normal;
    
    /* List the numeric variables you want to test here */
    var Happiness_Score 
        GDP_per_Capita 
        Family
        Life_Expectancy
        Freedom
        Government_Trust
        Generosity; 
        
/* Create a histogram overlaid with a normal curve */
    histogram Happiness_Score GDP_per_Capita 
              Family Life_Expectancy Freedom Government_Trust 
              Generosity / normal;
    
    /* Create a Q-Q plot for visual inspection */
    qqplot Happiness_Score GDP_per_Capita 
           Family Life_Expectancy Freedom Government_Trust 
           Generosity;

run;

/* =========================================================
   6. Create GDP_Category for the t-test 
   ========================================================= */
  
/* Find the average GDP per Capita */
title "Finding the Mean GDP";
proc means data=mylib.happiness_Cleaned mean;
    var GDP_per_Capita;
run;
title;

/* Create the new categorized dataset */
data mylib.happiness_Cleaned_final;
    set mylib.happiness_Cleaned;
    
    /* IMPORTANT: Replace 0.846 with your actual mean from Step 1 */
    if GDP_per_Capita >= 0.846 then GDP_Category = "Above Average";
    else if GDP_per_Capita < 0.846 and GDP_per_Capita not = . then GDP_Category = "Below Average";
run;

/* =========================================================
   7. EXPORT FINAL DATASET TO CSV
   ========================================================= */

proc export data=mylib.happiness_Cleaned_final
    outfile='/home/u64347364/STAT2044-ASM-NEW/Dataset_CLEAN/Happiness_Final_Cleaned.csv'
    dbms=csv
    replace;
run;

/* END */ 

