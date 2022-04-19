#!/usr/bin/env zsh
# Standarized $0 handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"


if [ -v "$FZF_DEFAULT_OPTS" ] 
then
	FZF_AWP_OPTS=$FZF_DEFAULT_OPTS
else
	fzf_awp_opts="--height 60% --layout=reverse --border"
fi

awp() {
  local aws_profile
  if [[ "$#" -eq 0 ]]; then
    aws_profile=$(aws configure list-profiles | fzf $fzf_awp_opts
  elif [[ "$#" -eq 1 ]]; then
    aws_profile=$(aws configure list-profiles | fzf -q ${1} --select-1 --exit-0 $fzf_awp_opts)
  fi
  export AWS_PROFILE="${aws_profile}"
}

awr() {
  local aws_region
  if [[ "$#" -eq 0 ]]; then
    aws_region=$(aws ec2 describe-regions \
                  --all-regions \
                  --query "Regions[].{Name:RegionName}" \
                  --output text | fzf $fzf_awp_opts)
  elif [[ "$#" -eq 1 ]]; then
    aws_region=$(aws ec2 describe-regions \
                  --all-regions \
                  --query "Regions[].{Name:RegionName}" \
                  --output text | fzf -q ${1} --select-1 --exit-0 $fzf_awp_opts)
  fi
  export AWS_REGION="${aws_region}"
}
