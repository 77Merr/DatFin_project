%{
a. 
Use five different "real" bonds and calculate for 
these bonds the yield to maturity, duration, and convexity.

austria -> https://www.investing.com/rates-bonds/austria-10-year-bond-yield
belgium -> https://www.investing.com/rates-bonds/belguim-10-year-bond-yield
france -> https://www.investing.com/rates-bonds/france-10-year-bond-yield
germany -> https://www.investing.com/rates-bonds/germany-10-year-bond-yield
spain -> https://www.investing.com/rates-bonds/spain-10-year-bond-yield
%}

% maybe look for face value, even though these are government bonds?

% data
format shortG
names = ["Austria", "Belgium", "France", "Germany", "Spain"];
num_bonds = length(names);

% 10 year bond yields choosen the 14th jan 2021
Austria_price = 103.735;
Belgium_price = 104.42;
France_price = 103.124;
Germany_price = 105.41; 
Spain_price = 111.578;

prices = [Austria_price, Belgium_price, France_price, Germany_price, Spain_price];
% since we are dealing with government bonds there are only two cash flows:
% one with the originial purchase and at maturity

Austria_coupon = 0.5;
Belgium_coupon = 0.1;
France_coupon = 0.5;
Germany_coupon = 0.25; 
Spain_coupon = 1.25;

coupons = [Austria_coupon, Belgium_coupon, France_coupon, Germany_coupon, Spain_coupon];


Austria_yield = -0.423;
Belgium_yield = -0.373;
France_yield = -0.326;
Germany_yield = -0.548;
Spain_yield = 0.064;

yields = [Austria_yield, Belgium_yield, France_yield, Germany_yield, Spain_yield];

Settle = datetime(2020,1,15);
Maturity = datetime([2030, 2, 20;...
                     2030, 6, 22;...
                     2030, 11, 25;...
                     2031, 2, 15; ...
                     2030, 10, 31]);


%                    
% computing yield to maturity; bond equivalent yield
% sovs: https://www.mathworks.com/help/finance/bndyield.html
% Price + Accrued Interest = sum(Cash_Flow*(1+Yield/2)^(-Time))

Austria_ytm = bndyield(prices(1), coupons(1), Settle, Maturity(1), 'CompoundingFrequency', 1); 
Belgium_ytm = bndyield(prices(2), coupons(2), Settle, Maturity(2), 'CompoundingFrequency', 1);
France_ytm = bndyield(prices(3), coupons(3), Settle, Maturity(3), 'CompoundingFrequency', 1);
Germany_ytm = bndyield(prices(4), coupons(4), Settle, Maturity(4), 'CompoundingFrequency', 1);
Spain_ytm = bndyield(prices(5), coupons(5), Settle, Maturity(5), 'CompoundingFrequency', 1);

% we're using annual
ytm = [Austria_ytm, Belgium_ytm, France_ytm, Germany_ytm, Spain_ytm];

disp("Yield to Maturity; annual");
disp([names; ytm*100]);

%disp("Yield to Maturity in percentage");
%disp([names; ytm*100]);

%
% computing duration
% sovs: https://www.mathworks.com/help/finance/bnddurp.html
%
[AU_ModDuration, AU_YearDuration, AU_PerDuration] = bnddurp(prices(1), coupons(1), Settle, Maturity(1), 'CompoundingFrequency', 1);
[BE_ModDuration, BE_YearDuration, BE_PerDuration] = bnddurp(prices(2), coupons(2), Settle, Maturity(2), 'CompoundingFrequency', 1);
[FR_ModDuration, FR_YearDuration, FR_PerDuration] = bnddurp(prices(3), coupons(3), Settle, Maturity(3), 'CompoundingFrequency', 1);
[DE_ModDuration, DE_YearDuration, DE_PerDuration] = bnddurp(prices(4), coupons(4), Settle, Maturity(4), 'CompoundingFrequency', 1);
[ES_ModDuration, ES_YearDuration, ES_PerDuration] = bnddurp(prices(5), coupons(5), Settle, Maturity(5), 'CompoundingFrequency', 1);

modD = [AU_ModDuration, BE_ModDuration, FR_ModDuration, DE_ModDuration, ES_ModDuration];
%macD = [AU_YearDuration, BE_YearDuration, FR_YearDuration, DE_YearDuration, ES_YearDuration];
%PeriodicMacaulayDuration = [AU_PerDuration, BE_PerDuration, FR_PerDuration, DE_PerDuration, ES_PerDuration];

disp("Duration; annual");
disp([names; modD]);

%disp("Macaulay Duration");
%disp([names; macD]);

%disp("Periodic Macaulay Duration");
%disp([names; PeriodicMacaulayDuration]);


%
% computing convexity
% sovs: https://www.mathworks.com/help/finance/bndconvy.html
%

[AU_YearConvexity,AU_PerConvexity] = bndconvy(ytm(1), coupons(1), Settle, Maturity(1), 'CompoundingFrequency', 1);
[BE_YearConvexity,BE_PerConvexity] = bndconvy(ytm(2), coupons(2), Settle, Maturity(2), 'CompoundingFrequency', 1);
[FR_YearConvexity,FR_PerConvexity] = bndconvy(ytm(3), coupons(3), Settle, Maturity(3), 'CompoundingFrequency', 1);
[DE_YearConvexity,DE_PerConvexity] = bndconvy(ytm(4), coupons(4), Settle, Maturity(4), 'CompoundingFrequency', 1);
[ES_YearConvexity,ES_PerConvexity] = bndconvy(ytm(5), coupons(5), Settle, Maturity(5), 'CompoundingFrequency', 1);

yc = [AU_YearConvexity, BE_YearConvexity, FR_YearConvexity, DE_YearConvexity, ES_YearConvexity];
%pc = [AU_PerConvexity, BE_PerConvexity, FR_PerConvexity, DE_PerConvexity, ES_PerConvexity];

disp("Convexity; annual");
disp([names; yc]);

%disp("Periodic Convexity Reported on a Semiannual Bond Basis");
%disp([names; pc]);


%{
b. 
Calculate the duration and convexity of a portfolio of 
these bonds, if EUR 100.000,-- is invested in each of them
%}
D_port = (1/num_bonds)*sum(modD(1:end));
C_port = (1/num_bonds)*sum(yc(1:end));

disp("Duration of the portfolio, if EUR 100.000 is invested in each");
disp(D_port);

disp("Convexity of the portfolio, if EUR 100.000 is invested in each");
disp(C_port);


%{
c. 
Estimate the potential decline in the market value of 
your portfolio, if the yield increases by 150 basis points.

sovs: https://www.mathworks.com/help/finance/sensitivity-of-bond-prices-to-interest-rates.html


delta_yieldCurve = 150/10000;
current_price = 100000*num_bonds;
weights = ones(num_bonds,1)/1;
amount = current_price*weights./prices';


new_duration = weights'.*modD;
new_convexity = weights'.*yc;

firstOrder = -new_duration*delta_yieldCurve*100;
secondOrder = firstOrder+new_convexity*delta_yieldCurve^2*100/2.0;

%priceFirstOrder = current_price+firstOrder*current_price/100;
%priceSecondOrder = current_price*secondOrder*current_price/100;

[Clean_price, Accrued_interest] = bndprice(ytm + delta_yieldCurve, coupons, Settle, Maturity);
priceTrue = amount'* (Clean_price + Accrued_interest);

disp("The true new price of the portfolio");
disp(priceTrue');
%}
deltaYield = 150/10000;
deltaPrice =  -D_port*deltaYield+0.5*C_port*(deltaYield)^2;
disp("The market value of our portfolio for a shift of 150 basis point in percentage");
disp(deltaPrice*100);