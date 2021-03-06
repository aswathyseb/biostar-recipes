# Bioinformatics Recipe Howto

## What is a bioinformatics recipe?

A recipe is a collection of commands with a graphical user interface.

A recipe may be a bash script, an R script, a series of mothur instructions. Basically any list of commands that can be executed in an environment.

## What is a purpose of a recipe?

Recipes allow other people to run scripts that you have written. When executed a recipe creates a full record of a data analysis run.

## Are recipes single software tools?

Typically no. A recipe is a series of actions that produce a full data analysis.

## Are recipe workflow engines?

No. `Make`, `snakemake`, and other workflow engines would be used inside a recipe.

## Is a recipe a "pipeline"?

Yes. A recipe may be thought of as a web enabled pipeline execution environment.

## Can command <...> be turned into a recipe?

Yes, if that command can be invoked from the command line.

## Can I copy and modify a recipe?

Yes. One of the main design elements focus on modifying and sharing recipes.

## Does a copied recipe become mine?

Yes. Once you copy a recipe it becomes yours. Your version may diverge from the original one.

## If I modify a recipe will my previous results be altered?

No. A result has a snapshot of the recipe as it existed at the time the run was initiated. If you alter a recipe you would need to re-run the analysis.

## What are recipes built from?

A recipe is built out of two files:

1. A graphical user interface (GUI) specification (aka the data)
2. The script itself as a template (aka the template).

## What is the GUI spec?

The GUI spec is a file in JSON (Javascript Object Notation). The GUI spec represents is data in  "dictionary" format.

## What is the minimal GUI spec?

The minimal GUI spec for a tool

    {}

This corresponds to an empty dictionary. When we want to specify more information we add fields to this dictionary.

## What is the minimal script?

An empty file is a valid script.

## Will a recipe with "nothing" in it work?

Yes. The recipe will have a `RUN` button and can be executed. It will produce log files that capture information about the "empty" run. For an example view the output of the first recipe in the tutorial list:

https://www.bioinformatics.recipes/recipe/list/tutorial/

## How do I specify a name for the recipe?

Add a field into the GUI spec:

    {
        settings: {
            name: Hello World!
        }
    }

## How do I specify a parameter for the recipe?

Add the parameter as a key to the recipe:

    {
        cutoff: {
            label: P-Value Cutoff
            display: FLOAT
            value: 0.05
            range: [ 0, 1]
        }

        settings: {
            name: Hello World!
        }
    }

The file above will generate an interface element called

![Cutoff](images/cutoff-parameter.png "Cutoff Parameter")

## How do I use a parameter in the script template?

If you have a parameter called `cutoff` as above you can use it in a recipe as

    {{ cutoff.value }}

The placeholder `{{ cutoff.value }}` will get substituted with the user selection in your script. If your script is in bash you could write:

    echo "You selected a cutoff of: {{ cutoff.value }}"

## How do I learn more about interfaces?

Visit the `Tutorial Project` and the `Biostar Cookbook` for examples of building interface elements and using them in scripts.

## What is  project?

A project is a collection of data, recipes and results.



