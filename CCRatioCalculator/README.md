# CC Ratio Calculator
The script CCRatioCalculator.r calculates CC ratios of pathway ranking tools using ranked lists of pathways.

```
Rscript CCRatioCalculator.r <list>
```
  
The <list> file includes phenotypes and pathes to pathway ranking files. It should have the format shown below:
  ```
  phenotype1  <ranked pathways for phenotype 1>.1 <ranked pathways for phenotype 1>.2
  phenotype1  <ranked pathways for phenotype 1>.3 <ranked pathways for phenotype 1>.4
  ...
  phenotype1  <ranked pathways for phenotype 1>.19 <ranked pathways for phenotype 1>.20
  phenotype2  <ranked pathways for phenotype 2>.1 <ranked pathways for phenotype 2>.2
  phenotype2  <ranked pathways for phenotype 2>.3 <ranked pathways for phenotype 2>.4
  ...
  phenotype2  <ranked pathways for phenotype 2>.19 <ranked pathways for phenotype 2>.20
  ...
  phenotype12  <ranked pathways for phenotype 12>.19 <ranked pathways for phenotype 12>.20
  ```
  
