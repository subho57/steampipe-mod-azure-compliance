with network_sg as (
  select
		distinct name sg_name
	from
		azure_network_security_group nsg,
		jsonb_array_elements(security_rules) sg,
		jsonb_array_elements_text(sg -> 'properties' -> 'destinationPortRanges' || (sg -> 'properties' -> 'destinationPortRange') :: jsonb) dport,
		jsonb_array_elements_text(sg -> 'properties' -> 'sourceAddressPrefixes' || (sg -> 'properties' -> 'sourceAddressPrefix') :: jsonb) sip
  where
    sg -> 'properties' ->> 'access' = 'Allow'
    and sg -> 'properties' ->> 'direction' = 'Inbound'
    and sg -> 'properties' ->> 'protocol' = 'TCP'
    and sip in ('*', '0.0.0.0', '0.0.0.0/0', 'Internet', 'any', '<nw>/0', '/0')
    and (
      dport in ('22', '*')
      or (
        dport like '%-%'
        and split_part(dport, '-', 1) :: integer <= 22
        and split_part(dport, '-', 2) :: integer >= 22
      )
    )
)
select
  -- Required Columns
  sg.id resource,
  case
    when nsg.sg_name is null then 'ok'
    else 'alarm'
  end as status,
  case
    when nsg.sg_name is null
      then sg.title || ' restricts SSH access from internet.'
    else sg.title || ' allows SSH access from internet.'
  end as reason,
  -- Additional Dimensions
  sg.resource_group,
  split_part(sg.subscription_id, '-', 5) as subscription_id
from
  azure_network_security_group sg
  left join network_sg nsg on nsg.sg_name = sg.name;