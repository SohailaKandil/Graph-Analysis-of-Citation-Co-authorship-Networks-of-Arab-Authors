import pandas as pd 

data = pd.read_csv("papers_data_from_rcrossref_Qatar.csv")
data_cleaned = data.drop_duplicates(subset = ["doi"])
data_cleaned = data.dropna(subset = ["doi" , "author" , "title"])

data_cleaned.to_csv("papers_data_from_rcrossref_Qatar_cleaned.csv" , index = False)
print("Duplicates removed and cleaned file saved")

