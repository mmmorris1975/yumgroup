yumgroup CHANGELOG
==================

0.1.0
-----
- [michael.m.morris@gmail.com] - Initial release of yumgroup

0.2.0
-----
- [michael.m.morris@gmail.com] - Added lwrp option to update metadata cache before or after group install/upgrade

0.3.0
-----
- [michael.m.morris@gmail.com] - Added lwrp option to make failures of metadata cache updates fatal

0.3.1
-----
- [michael.m.morris@gmail.com] - Changed bundle process from tar to 'knife cookbook site share'

0.4.0
-----
- [michael.m.morris@gmail.com] - Changes to test and use Chef 12 (should still be Chef 11 compliant!)

0.5.0
-----
- [michael.m.morris@gmail.com] - Resolve #1, add idempotency to :install and :remove lwrp actions.  Many thanks to @thenoid,  @nsdavidson, and @zachsmorgan

1.0.0
-----
- [@detjensrobert](https://github.com/detjensrobert)
  - Refactor legacy LWRP to custom resource
  - Update test infra to latest tooling
  - Cookstyle linting fixes
  - Enable `unified_mode` for Chef 17 compatibility
  - Guard against non-RHEL distros
