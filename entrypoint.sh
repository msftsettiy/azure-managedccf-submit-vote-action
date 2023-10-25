#!/bin/bash

cd /opt/ccf_sgx/bin
proposal_id=$(eval echo $1)

echo "$CERTD" > /opt/ccf_sgx/bin/cert
echo "$KEYD" > /opt/ccf_sgx/bin/key

echo "Submitting a vote on the proposal $proposal_id."
content=$(ccf_cose_sign1 --ccf-gov-msg-type ballot --ccf-gov-msg-created_at `date -Is` --signing-key key --signing-cert cert --content accept.json --ccf-gov-msg-proposal_id $proposal_id| curl ${CCF_URL}/gov/proposals/$proposal_id/ballots -k -H "content-type: application/cose" --data-binary @-)
echo "Response from CCF: $content"
status=$(echo "${content}" | jq '.state')
echo "Voting status: $status"
echo "status=$status" >> $GITHUB_OUTPUT
