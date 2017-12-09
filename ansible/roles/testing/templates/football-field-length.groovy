#!/usr/bin/env groovy

@GrabResolver(name='{{ nexus_repos_maven_group[0].name }}', root='{{ maven_pull_repo_url }}')
@Grab("edu.ucar:unit-utils:1.0.0-SNAPSHOT")
import edu.ucar.UnitUtils

printf "One football field is equal to %.2f meters.%n", UnitUtils.convertYardsToMeters(100)
