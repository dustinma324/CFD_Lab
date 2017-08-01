#!/bin/bash

#Account and Email Information
###SBATCH --mail-type=end
###SBATCH --mail-user=USERNAME@u.boisestate.edu

# Specify parition (queue)
#SBATCH --partition=MRI

# Join output and errors into output
#SBATCH -o Cylinder_slurm.o%j
#SBATCH -e Cylinder_slurm.e%j

# Specify job not to be rerunable
#SBATCH --no-requeue

# Job Name
#SBATCH --job-name="Cylinder_Re100"

#Exclusively check out a node
#SBATCH --exclusive

# Specify walltime
###SBATCH --time=300:00:00

# Specify number of requested nodes:
#SBATCH --nodes=1

# Specify the total number of requested procs:
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=2

# Specify the number of requested GPUs per node.
#SBATCH --gres=gpu:2

module purge
module load slurm
module load gin3d/cuda75/4.0

cd $SLURM_SUBMIT_DIR

RUNDIR=$SLURM_JOB_NAME.$(echo $SLURM_JOB_ID | cut -d '.' -f 1)

mkdir $RUNDIR
cd $RUNDIR

BINDIR=/home/DustinMa/Desktop/CFDlab/Setup
IBDIR=$BINDIR/Cylinder
EXEC=gin3d_turbibm_single
STEPS=1000000

###mpirun $BINDIR/$EXEC -c $IBDIR/*.cfg $STEPS
srun --kill-on-bad-exit --mpi=pmi2 --cpu_bind=map_cpu:8,9 $BINDIR/$EXEC -c $IBDIR/*.cfg $STEPS
                                                   
