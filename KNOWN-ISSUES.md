# Known Issues

## Tags not inherited by imported tasks

Previously, we could execute only the tasks in 'ansible-nexus3-oss' with:

```
ansible-playbook --ask-vault-pass -i inventories/dev/hosts -v site.yml --tags "nexus"
```

As of Ansible 2.5.0, this is no longer possible, because attributes applied to `include_tasks` (in particular its
`tags`) are not inherited by the tasks within [<1>](
http://docs.ansible.com/ansible/devel/porting_guides/porting_guide_2.5.html#dynamic-includes-and-attribute-inheritance).
'ansible-nexus3-oss' uses `include_tasks` a lot.

The doc recommends "to use a static `import_*` when possible instead of a dynamic task", as attributes applied to
them ARE inherited by the tasks within. Unfortunately, this is not always doable because many of ansible-nexus3-oss's
`include_tasks`s employ loops, which is not possible with `import_*` [<2>](
http://docs.ansible.com/ansible/devel/user_guide/playbooks_reuse.html#tradeoffs-and-pitfalls-between-includes-and-imports).
