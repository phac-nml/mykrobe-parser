## Legal ##
-----------

Copyright Government of Canada 2018

Written by: National Microbiology Laboratory, Public Health Agency of Canada

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this work except in compliance with the License. You may obtain a copy of the
License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Contact ##
-------------

**Gary van Domselaar**: gary.vandomselaar@canada.ca


## Mykrobe Parser ##
---------------------

Mykrobe Parser is an R Script that parses the *Mycobacterium tuberculosis* specific results of [Mykrobe](https://github.com/Mykrobe-tools/mykrobe). It seperates mutations into indivudal genetic regions and presents them in a tidy data format compatible with reporting.

Mykrobe Parser is compatible with [Mykrobe v0.7.0](https://anaconda.org/bioconda/mykrobe/files?version=0.7.0) and the "201901" panel.

**Notes**
* Samples that Mykrobe detects non-tuberculous mycobacteria in are removed for quality control purposes.
* If prediction for one gene fails in Mykrobe, Mykrobe parser will set all "[antimicrobial]_prediction" columns to "failed" and all genetic regions to "NA".

## Installing Mykrobe Parser ##
Dependancies:
*  Conda
*  Git (optional)

Download this repository or use git to clone this repository.

```sh
git clone https://github.com/phac-nml/mykrobe-parser.git
```

**Use Conda to install required R dependancies**

The `mykrobe_parser_installation.yml` file is found in the R directory of this repository.

```sh
conda env create -f mykrobe_parser_installation.yml
```

##  Mykrobe ##

[Mykrobe](https://github.com/Mykrobe-tools/mykrobe) is an open-sourced program the can predict antimicrobial resistance from *Staphylococcus aureus* and *Mycobacterium tuberculosis*.

> [Bradley P, Gordon NC, Walker TM, Dunn L, Heys S, Huang B, et al. Rapid antibiotic-resistance predictions from genome sequence data for Staphylococcus aureus and Mycobacterium tuberculosis. Nat Commun. 2015;6: 10063. doi:10.1038/ncomms10063](http://www.nature.com/ncomms/2015/151221/ncomms10063/full/ncomms10063.html)  

> [Hunt M, Bradley P, Lapierre SG, Heys S, Thomsit M, Hall MB, et al. Antibiotic resistance prediction for Mycobacterium tuberculosis from genome sequence data with Mykrobe. Wellcome Open Res. 2019;4: 191. doi:10.12688/wellcomeopenres.15603.1](https://wellcomeopenresearch.org/articles/4-191)  


### Mykrobe Parameters ###

To be compatible with Mykrobe Parser, Mykrobe must be run using the following arguments:

    --format json
        * Stores results a .json file instead of a text file. Mykrobe Parser only works with json files. 

    --panel 201901
        * Uses the "201901" panel for resistance prediction. This is the only panel currently compatabile with Mykrobe Parser.


## Running Mykrobe Parser ##

**Necessary arguments**

    -d 
        (directory where the Mykrobe json files are stored)

    or

    -f 
        (a file path, or list of file paths to Mykrobe json files -eg. "~mykrobe-parser/data/FILE1.json,~mykrobe-parser/data/FILE2.json)

**Optional arguments**

These arguments encode text into the final output  

     -v CHARACTER , --version 
         Stores text to the "Mykrobe_Workflow_Version" column. This is meant to store the pipeline or Galaxy Workflow version.  

    -D INTEGER, --depth  
        Stores the '--min_depth' argument used to run Mykrobe [default= 5])  

    -c INTEGER, --conf
        Stores the '--min_variant_conf' argument used to run Mykrobe [default= 10]  

    -n CHARACTER, --name
        Stores text to the "Mutation_set_version". This is meant to store a simple version number for the Mykrobe_Resistance_probe_set (instead of tb-hunt-probe-set-jan-03-2019.fasta.gz).
    
    -r CHARACTER, --reportfile
        Changes the name of the antimicrobial susceptibility report file. [Default = output-[panel&version]-report.csv]

    -s CHARACTER, --speciationfile
        Changes the name of the antimicrobial susceptibility report file. [Default = output-[panel&version]-speciation_data.csv]

** Running Mykrobe Parser **

```sh
Rscript PATH/TO/R/01_[Appropriate_Script_Version].R -d PATH/TO/Mykrobe_json_files
```

#### Outputs ####

Mykrobe Parser creates two files called "output-report.csv" and "output-speciation_data.csv" by default.  

output-report.csv
*  Stores Mykrobe's antimicrobial resistance data. 
*  The following columns are placeholders for internal data: "Lims_Comment", "Lims_INTComment", "LIMS_file".
  
output-speciation_data.csv
*  Stores Mykrobe's speciation data such as "phylo_group", "species", and "lineage" and their associated depths and percentages of coverage.  
