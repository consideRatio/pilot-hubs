# Import the various subcommands here, they will be automatically
# registered into the app
import deployer.commands.cilogon  # noqa: F401
import deployer.commands.debug  # noqa: F401
import deployer.commands.deployer  # noqa: F401
import deployer.commands.exec.cloud  # noqa: F401
import deployer.commands.exec.infra_components  # noqa: F401
import deployer.commands.generate.billing.cost_table_cmd  # noqa: F401
import deployer.commands.generate.dedicated_cluster.aws_commands  # noqa: F401
import deployer.commands.generate.dedicated_cluster.gcp_commands  # noqa: F401
import deployer.commands.generate.helm_upgrade.jobs_cmd  # noqa: F401
import deployer.commands.grafana.central_grafana  # noqa: F401
import deployer.commands.grafana.deploy_dashboards  # noqa: F401
import deployer.commands.grafana.tokens  # noqa: F401
import deployer.commands.validate.config  # noqa: F401
import deployer.keys.decrypt_age  # noqa: F401

from .cli_app import app


def main():
    app()
