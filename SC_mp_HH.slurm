#!/bin/bash
#
#SBATCH --array=1-615%123
#SBATCH --job-name=SC_mp_HH
#SBATCH --output=/SC_mp_HH/Output_MATLAB/%a.out
#SBATCH --error=/SC_mp_HH/Error_reports/%a.err
#SBATCH --mem=4G

uname -n 1>&2

i=$(($SLURM_ARRAY_TASK_ID))

/opt/apps/matlabR2016a/bin/matlab -r "mod_prmtr.model_name = 'SC_mp'; mod_prmtr.id = ${i}; out_ctrl.if_save_data = 1; out_ctrl.if_write_log = 1; out_ctrl.if_plot = 1; main_MS_HH( mod_prmtr, out_ctrl ); quit;"