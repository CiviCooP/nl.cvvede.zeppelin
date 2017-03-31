<?php

/**
 * Collection of upgrade steps.
 */
class CRM_Zeppelin_Upgrader extends CRM_Zeppelin_Upgrader_Base {

  public function install() {
    $this->executeSqlFile('sql/install.sql');
  }

  public function uninstall() {
   $this->executeSqlFile('sql/uninstall.sql');
  }

}
