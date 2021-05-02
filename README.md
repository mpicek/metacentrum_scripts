# Metacentrum Scripts

This is a repository containing scripts to make your work with Metacentrum
servers easier. Metacentrum is a grid of powerfull computers provided by CESNET to 
the czech academy - students, researchers, teachers,.. - **for free**.

There are [rules](https://wiki.metacentrum.cz/wiki/Usage_rules)
you should definitely read, but I want to point out
one of the most important one (for me). If you use Metacentrum, please
use the [acknowledgement formula](https://wiki.metacentrum.cz/wiki/Usage_rules/Acknowledgement).

I also recommend to read this [Beginners guide](https://wiki.metacentrum.cz/wiki/Beginners_guide#Track_your_job).
It is very simply put.

I also provide links to the Metacentrum Wiki - all in English. Right now I want to point out that
most of the pages are also in Czech language. Take advantage of this fact when
Czech is more convenient for you :)

# Registration

**In order to use Metacentrum you need to be registerd. You can do so [here](https://metavo.metacentrum.cz/en/application/index.html).

If you also want to use GPU, you have to [agree to the cudnn license](https://wiki.metacentrum.cz/w/index.php?title=CuDNN_library&setlang=en).**

# Usage of The Scripts

Connect via SSH to some of the Frontend server:
```bash
ssh user_name@tarkil.grid.cesnet.cz
```
and type in your password.

Then change directory to `/storage/budejovice1/home/user_name`. This directory
will be used as our storage directory as it has 102Gb quota:
```bash
cd /storage/budejovice1/home/user_name
```

**Create a file similar to `commands_example`. Each of the commands will
be run in separate jobs** - it is good for tuning hyperparameters as you
specify them in the command parameters. Some rules:
 - you can write comments with `#`
 - each command has to be separated from another one by either a comment or
   one empty line
 - if you are creating an ensemble, only the first command will be run (more info in "Creating an Ensemble")

**Then you create a bash script that will setup the VM you aquire from Metacentrum.
As an example, there is `qsub_script.sh` which setups Tensorflow 2.4.1 environment
with GPU.** It is recommended to use this script - just
edit it the way you want. Why is it recommended to use this script?
There are many ways you can setup Tensorflow on Metacentrum - with the help of pip, 
there are also modules
provided by Metacentrum, or you can just compile the Tensorflow
on your own. But what's the problem? You will almost certainly encounter
problems with improperly installed CUDA (or just too old version).
However, the most convenient and recommended way is to use NGC containers
that provide TF and CUDA installed and ready to use. 
This approach is maintained by Metacentrum and is also recommended by them. 
You can find out more [here](https://wiki.metacentrum.cz/wiki/NVidia_deep_learning_frameworks).


**At the beginning of the file you have to specify
the resources (lines beginning with PBS)**. It is very straightforward, you
will probably have to alter just some numbers.
You can find more [here](https://wiki.metacentrum.cz/wiki/Beginners_guide).


Both of these files will be passed to the `run_commands.py` script like this:

```bash
./run_commands.py --command_file=commands_example --script=qsub_script.sh --repository=npfl114-solutions/labs --program_path=labs/08
```

where:
 - `--command_file` - file with commands to be run
 - `--script` - script that sets the VM up and runs Singularity
 - `--repository` - is a path to the repository from your home directory
 - `--program_path` - when VM is executed and repository copied, you have your
 repository ready in the VM. This is a path in your VM to the folder where your
 later executed program can be found.

# Where is the output of my scripts?

When you run the `run_commands.py` script, your commands are sent to the PBS
queue where they wait for the execution. They are also given an ID that identifies
the job. After the job is done, the output is saved to the folder, where you were
located when you ran the `run_commands.py` script. You will see new files similar to these two:
`qsub_script.e7448636`, `qsub_script.o7448636` (provided your script was called `qsub_script.sh`).

The first one is an error output (stderr) from job 7448636 and the second one is
a regular output (stdout) from the same job. You can print it and see the output of your job.

You can also monitor your jobs [here](http://metavo.metacentrum.cz/pbsmon2/person).

## Creating an Ensemble

If you want to create an ensamble of one specific model, just 
create a command file where will be just the one command to be run. If there are more,
only the first one will be run.

Then run:

```bash
./run_commands.py --command_file=commands_example --script=qsub_script.sh --repository=npfl114-solutions/labs --program_path=labs/08 --models=20
```

Your model should create folder `submodel<SEED>` where `<SEED>` is the seed it
obtains since it is used as an identificator of the model in an ensemble (so for example `submodel42`).
It must be created in the folder where the program is run. And what should
the folder contain? It is on you, but the purpose of this folder is to store
the trained model in it and use copy it to your storage folder to be later
used for ensembling.

Now you can create another job that will connect all the ensembles together.

## Grid Search

Please, don't use the `grid_search.py` script. It is still not ready and it can
do harm to either you or to the Metacentrum.