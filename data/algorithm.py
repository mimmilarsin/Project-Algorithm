# Algorithm in python

# Algorithm Tasks: ----
# For a set of publications, determine the:
# (1) number of collaborators
# (2) collaboration types

# load libraries
import pandas as pd

# read dataset
ds = pd.read_csv('A2_Algorithm Design/three-by-three/data/testDataset.csv')

#print(ds.to_string())

# Task 1
ds_t1 = ds.copy()
ds_t1.insert(1, "collabNum", "")

for x in ds_t1.index:
    if ds_t1.loc[x, "NumberOfAuthors"] == 1:
        ds_t1.loc[x, "collabNum"] = "individual"
    elif ds_t1.loc[x, "NumberOfAuthors"] == 2:
        ds_t1.loc[x, "collabNum"] = "pair"
    else:
        ds_t1.loc[x, "collabNum"] = "group"

print(ds_t1)
# End Task 1

# Task 2
task2 = ds_t1.take([0,2], axis=1)

task2 = task2.join(task2["Name"].str.split(";", expand=True))

task2melt = task2.melt(id_vars=["PID","Name"], var_name="AuNum", value_name="Author", ignore_index=False)

task2melt[["Author_ID","affiliation"]] = task2melt["Author"].str.split(", \\(", expand=True)
task2melt["affiliation"] = task2melt["affiliation"].str.strip("\\)")
task2melt[["organization","country"]] = task2melt["affiliation"].str.split(",", expand=True)

task2grouped = task2melt.groupby("PID", as_index=False).nunique().take([0,4,6,7], axis=1)

task2grouped.insert(1,"collabType","")
for x in task2grouped.index:
    if task2grouped.loc[x, "Author_ID"] == 1:
        task2grouped.loc[x, "collabType"] = "no collaboration"
    elif task2grouped.loc[x, "organization"] == 1:
        task2grouped.loc[x, "collabType"] = "local"
    elif task2grouped.loc[x, "country"] == 1:
        task2grouped.loc[x, "collabType"] = "national"
    else:
        task2grouped.loc[x, "collabType"] = "international"

ds_t2 = task2grouped.take([0,1], axis = 1)

result = pd.merge(ds_t1, ds_t2, on="PID")
result.insert(1, "collabType", result.pop("collabType"))
print(result.take([0,1,2], axis=1))
# End Task 2