class AvatarCatalogItem {
  final String assetPath;
  final String name;
  final int requiredLevel;
  final int coinCost;

  const AvatarCatalogItem({
    required this.assetPath,
    required this.name,
    required this.requiredLevel,
    required this.coinCost,
  });
}

const avatarCatalog = <AvatarCatalogItem>[
  AvatarCatalogItem(
    assetPath: 'assets/avatars/brook.JPG',
    name: 'Brook',
    requiredLevel: 1,
    coinCost: 0,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/chopper.JPG',
    name: 'Chopper',
    requiredLevel: 2,
    coinCost: 40,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/franky.JPG',
    name: 'Franky',
    requiredLevel: 3,
    coinCost: 60,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/jinbe.JPG',
    name: 'Jinbe',
    requiredLevel: 4,
    coinCost: 80,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/luffy.JPG',
    name: 'Luffy',
    requiredLevel: 5,
    coinCost: 100,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/nami.JPG',
    name: 'Nami',
    requiredLevel: 6,
    coinCost: 120,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/robin.JPG',
    name: 'Robin',
    requiredLevel: 7,
    coinCost: 140,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/sanji.JPG',
    name: 'Sanji',
    requiredLevel: 8,
    coinCost: 160,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/usopp.JPG',
    name: 'Usopp',
    requiredLevel: 9,
    coinCost: 180,
  ),
  AvatarCatalogItem(
    assetPath: 'assets/avatars/zoro.JPG',
    name: 'Zoro',
    requiredLevel: 10,
    coinCost: 200,
  ),
];
