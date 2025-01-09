'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/asset/abstral-official-aClNr1q61Cg-unsplash.jpg": "6997d2791c3a0bc5e865face4df34168",
"assets/asset/action-3195378.jpg": "c7e068d657e12e6cadd491fb4ea2c14b",
"assets/asset/ai-generated-8559579.jpg": "1dff7f3166f8e5aa1bd717f069984412",
"assets/asset/ali-kanibelli-VeX_ZAqYg3I-unsplash.jpg": "674bba84d29be10bf61a2c16a3e84e45",
"assets/asset/amir-maleky-pbxUrGBNVc0-unsplash.jpg": "abb291a8f0b6fdda969fadaf5d1f226a",
"assets/asset/Animation%2520-%25201728643625531.json": "9ed07c891ff7687b7db1f1564ad0b172",
"assets/asset/Animation%2520-%25201729398055158.json": "64a23394ebd6dd09454883315f67dddc",
"assets/asset/Animation%2520-%25201729773236296.json": "59743984997585c815ddf512914e2c7e",
"assets/asset/back-view-crowd-fans-watching-live-concert-performance-6.jpg": "e3e7405b90b17cd11fc332f285c1a0c8",
"assets/asset/back-view-crowd-fans-watching-live-performance-music-concert-night-copy-space.jpg": "e824141689a05050025781583e3e3fe5",
"assets/asset/back-view-excited-audience-with-arms-raised-cheering-front-stage-music-concert-copy-space.jpg": "7812836b11bd2705be707a92edc8c8fe",
"assets/asset/band-6568049.jpg": "8a8407dd45816ec896e26872e1068d79",
"assets/asset/benjamin-lehman-sWVu4iFkhk8-unsplash.jpg": "2b04cb52e2fe783981cb1f61f5dd79f3",
"assets/asset/concert-2566001.jpg": "c18477078325630b90b8a904b7f72579",
"assets/asset/concert-601537.jpg": "8cc5c25c9aaa520dbbd8737123747881",
"assets/asset/crowd-people-with-raised-arms-having-fun-music-festival-by-night.jpg": "33bd723083d28ec51acb6e17a4012d8c",
"assets/asset/fabio-oyXis2kALVg-unsplash.jpg": "ee94aa3c11dd09042e562be25987eec9",
"assets/asset/flavio-anibal-m6nTS8pgHbw-unsplash.jpg": "551fc93c38b2c15535880090e4a38adb",
"assets/asset/flavio-anibal-p1J1-o6nV8I-unsplash.jpg": "dbb11d8996f4d8edcf1d962bdc6b47c7",
"assets/asset/hoach-le-dinh-4GuylznlPk8-unsplash.jpg": "1ae05e59e33d8b10f1dd8869161df43e",
"assets/asset/joes-valentine-UW0fop9eUo0-unsplash.jpg": "13fad3ecf241ae41d2803e3bab706b2c",
"assets/asset/josh-rocklage-qE851OTuYIk-unsplash.jpg": "30a905f2c6325e2af8051892c56b0254",
"assets/asset/keyboards-3555057.jpg": "668f4cdd0e777748e24ce2893e9174b2",
"assets/asset/nadia-sitova-Tlwrp8ThUg8-unsplash.jpg": "20335076bc71925460060f59200ab429",
"assets/asset/pablo-de-la-fuente-UPexcwb9S94-unsplash.jpg": "eae11d0f0302769974a0ca5a1c972b85",
"assets/asset/pavel-pjatakov-S3G5un6xgyw-unsplash.jpg": "8bc855d096ee5d3956892422835dde2f",
"assets/asset/pngwing.com.png": "51791544f2482d53a28225ae7ef91dfe",
"assets/asset/romina-veliz-DGKJzOmjyS4-unsplash.jpg": "09e18aff446316c9fe4daa5143df773a",
"assets/asset/seamless-vector-pattern-with-abstract-matisse-style-shapes-lines-corals-leaves-contemporary-art_522613-584.jpg": "332c3b1f834c268b4573e2cdfacba95d",
"assets/asset/sincerely-media-Nixsk3W1XzM-unsplash.jpg": "9972072dd6fd5ff916f642089826b212",
"assets/asset/singer-4915484.jpg": "98520a630d8152cf788308fe0562950c",
"assets/asset/singer-5467009.jpg": "063d65d502ff7c82762f7f0a719e078d",
"assets/asset/sound-3752999.jpg": "d148155963f068f09b68d177a5c28a6e",
"assets/asset/WhatsApp%2520Image%25202024-10-01%2520at%252009.37.05_044c4e8f.jpg": "332c3b1f834c268b4573e2cdfacba95d",
"assets/asset/william-recinos-qtYhAQnIwSE-unsplash.jpg": "ada32c59704e8b411837616535e5c24d",
"assets/asset/zac-bromell-pNRvOifHyZ8-unsplash.jpg": "26bdd0f573975a1e1e5015c729a8e8de",
"assets/asset/zachrie-friesen-H_wGRt781Vk-unsplash.jpg": "8de9d1d61ec720a5234d21c76017735e",
"assets/AssetManifest.bin": "81d15997f23dd29a1d7233ca18090c15",
"assets/AssetManifest.bin.json": "1a2333ff45a9772105b6d2384c3171ef",
"assets/AssetManifest.json": "41b221cd733e1079a7a63c4ef8b213af",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "eafb29ae317c37bec5b635c981efa50b",
"assets/NOTICES": "3cfe51e67bb4ff94d099cf82978c6856",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "d98a2d6e0904c70ce4e2cad6f595ef67",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "71a084fe541382d6b8be7a3c90dc8188",
"/": "71a084fe541382d6b8be7a3c90dc8188",
"main.dart.js": "112e85c7d3d69ce6dc26fe965a722f26",
"manifest.json": "4515a419b098e49e7afc1a1e31dea084",
"version.json": "342488255cdef9f968a284a644564171"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
