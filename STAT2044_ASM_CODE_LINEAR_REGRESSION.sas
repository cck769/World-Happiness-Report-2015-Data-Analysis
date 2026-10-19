/* 

Creator: Palaniandy Sri 
Student ID: 23063753
Objective of program: To perform multiple linear regression analysis to identify the economic, social, health, freedom, generosity and government factors
that significantly predict Happiness Score in the 2015 World Happiness dataset.

*/

/* =========================================================
   1. Import the cleaned dataset
   ========================================================= */

/* Import the cleaned 2015 World Happiness dataset into SAS
   for multiple linear regression analysis. */

proc import
    datafile="/home/u64347364/STAT2044-ASM-NEW/Dataset_CLEAN/Happiness_Final_Cleaned.csv"
    out=work.happiness
    dbms=csv
    replace;

    getnames=yes;

run;

/* =========================================================
   2. Multiple Linear Regression
   ========================================================= */

/* Fit a multiple linear regression model to determine
   whether GDP per Capita, Family, Life Expectancy,
   Freedom, Generosity and Government Trust significantly
   predict Happiness Score. */

ods graphics on;

proc reg data=work.happiness
         plots(only)=(diagnostics residuals);

    model Happiness_Score =
          GDP_per_Capita
          Family
          Life_Expectancy
          Freedom
          Generosity
          Government_Trust
          / vif
            tol
            clb
            stb;

    title "Multiple Linear Regression Results for Happiness Score";

run;

quit;

ods graphics off;

/* END */
