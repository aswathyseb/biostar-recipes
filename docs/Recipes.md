## Collabrative Ananlysis in Bioinformatics 
![](./images/collab.jpg ) 
Natay Aberra 
Aswathy Sebastian 
Istavan Albert 


---

## Introduction 

- __Dr. Istvan Albert__ - Professor of Bioinformatics, enabled the project.

- __Aswathy Sebastian__ - Bioinformatician, wrote pipelines used for metabarcode analysis

- __Natay Aberra__ - Programmer, made platform used to run and share pipelines. 
![](./images/state.png)

---

## Metabarcoding project

Classify population of fish using different analytic pipelines and compare their results.

Guiding princlipes when making our pipelines:
- Written to be easily tuneable and reproducible. 
	- In principal, a pipeline written to classify fish should be able to classify anything else. 


---

## Broader issue 

In many cases, one lab can not recreate the results of another even if both start with the same data set.


- __Problem__ : Bioinformatics is experiencing a _reproducibility crisis_. 
- __Solution__ :  A web application allowing scientists to document, execute and share data analysis scripts. 
	- We call these analysis scripts ___recipes___. 
  
---
## Biostar-Engine: A sharing platform


The website : https://www.bioinformatics.recipes/

Designed to facilitate __sharing__ and __reproducibility__.

Additional features:
- Generates an easy-to-use graphical interface to command line tools
- Supports public and private project-based workflows
- Data storage

The software that runs this website is called [Biostar-Engine](https://github.com/biostars/biostar-engine)



---

## Recipe vs. Engine

The engine/platform is independant from the analysis scripts that run on it.

Recipes are generic and their use is not limited to the this website. A recipe from this site can be executed on any system that has the required bioinformatics tools installed.


---

#### Bioinformatic Recipes 

A recipe is a pipeline with an added graphical interface ( GUI ).
1. The commands may be any list of commands that can be executed in an environment. `echo "Hello World!"`
  
2. The GUI spec is a file in JSON (Javascript Object Notation).

      
        {
            cutoff: {
                label: P-Value Cutoff
                display: FLOAT
                value: 0.05
                range: [ 0, 1]
                }
        }
   
 	![](./images/cutoff-parameter.png)


---
## How do I use a parameter in the script template?
![](./images/cutoff-parameter.png)

If you have a parameter called cutoff as above you can use it in a recipe as `{{ cutoff.value }}`.

The placeholder `{{ cutoff.value }}` will get substituted with the user selection in your script. If your script is in bash you could write:

	echo "You selected a cutoff of: {{ cutoff.value }}"

---
___Is a recipe a "pipeline"?___
<sub>Yes. A recipe may be thought of as a web enabled pipeline execution environment.</sub>

___What is the minimal requirment?___
<sub>An empty GUI spec dictonary `{}` and an empty template make the simplest recipe. </sub>

___Easiest way to get someones recipe?___
<sub>Just copy it ! Anyone that can see a recipe can copy their own version of it. </sub>

---

## Where to start

1. Create a project
	- <sub>Projects act as containers for recipes, data, and analytic results.</sub>
	
2. Add data into project
	- <sub>Several methods to add data, some have restirctions on size.</sub>

3. Create a recipe 
	- <sub>Create a blank recipe or copy one and edit it.</sub>

4. Run the recipe and view results
	- <sub>Running a recipe creates a set of files that can be downloaded or re-ran in another recipe.</sub>

---
## General structure 

![](./images/todo/project-view.png)
Each project has three distinct sections:

- __Data__: Sequencing runs, sample sheets, etc.
- __Recipes__: Graphic interface + pipeline
- __Results__: files generated from running recipes

The __Results__ are created by applying a __Recipe__ on __Data__.


---
## Create a project

Get full `READ` + `WRITE` + `MANAGE` access to projects you create

<sub>To create a project, click the `Create Project` button found at the bottom of the `Project List` page.</sub>



---

## Add data
__Uploding data__:
- Large data ( > 25 MB): 
	- Currently: ask site admin to add it manually 
	- Final release: an FTP server
- Text entries ( 10k charachers ):
	- Write into a text box instead of uploading a file. 
	
__Copying data__:
- Copy from other projects you have access to.





---
## Create recipe 




---
## Run and view results

---
# Live Demo!
https://www.bioinformatics.recipes/







