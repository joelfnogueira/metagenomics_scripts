#! /bin/bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=120G
#SBATCH --gres=lscratch:200
#SBATCH --mail-type=ALL
#SBATCH --mail-user=padmanr@ccf.org
#SBATCH --mail-type=BEGIN,END,FAIL

################################################################################
#                                  Functions                                   #
################################################################################

function log() {
    local level=$1
    shift
    echo "$level:$(date '+%F %T'):$@" >&2
}
function info() {
    log INFO "$@"
}
function error() {
    log ERR "$@"
}
function fail() {
    log ERR "$@"
    exit 1
}

################################################################################
#                                    Setup                                     #
################################################################################

# database to be used - adapt to your needs
KDB_PATH=/home/padmanr/lustre/kraken_bvfpa_080416
KDB_NAME=20160111_viruses

if [[ $# -ne 1 ]]; then
    echo "USAGE:"
    echo "  sbatch test.sh seqfile_list"
    echo ""
    echo "where seqfile_list is a file listing input files (one per line)"
    exit 1
fi
if [[ -e $1 ]]; then
    info "will process $(cat $1 | wc -l) files in this run"
    input_files="$1"
else
    fail "'$1' does not exist"
fi

# load modules
module load kraken/0.10.5-beta || fail "unable to load kraken module"
module load parallel/20141122 || fail "unable to load gnu parallel module"

# copy the standard kraken db to local disk
# this is not required 

if [[ ! -d /lscratch/${SLURM_JOBID}/${KDB_NAME} ]]; then
    info "START: copy kraken database '${KDB_PATH}/${KDB_NAME}'"
    cp -r ${KDB_PATH}/${KDB_NAME} /lscratch/${SLURM_JOBID} \
        || fail "Unable to copy kraken db to local disk"
    info "DONE:  copy kraken database"
else
    info "SKIP:  local kraken database already exists"
fi

# set up a temp dir for gnu parallel
tmpd=$(mktemp -d /lscratch/${SLURM_JOBID}/XXXX)
info "gnu parallel temp dir: ${tmpd}"


################################################################################
#                                   Run jobs                                   #
################################################################################
# run kraken on the sequence files provided on the command line

cmd="kraken --db /lscratch/${SLURM_JOBID}/${KDB_NAME} --fasta-input --threads=8 --output {/.} {} &> {/.}.log"
info "command: ${cmd}"

info "START: gnu parallel run"
parallel -j4 \
    --tmpdir=${tmpd} \
    --tagstring {/.} \
    --joblog=./parallel.log \
    --keep-order \
    --verbose \
    -a ${input_files} \
    "$cmd"
info "DONE:  gnu parallel run"
