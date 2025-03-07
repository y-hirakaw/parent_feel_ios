* このアプリで利用されているSVVSアーキテクチャについての説明
  * SVVSでは、ViewのアクションがViewStateを通じてStoreに伝達されます。StoreはAPIやDBと通信し、シングルトンでデータを保持します。
  * Storeのデータ変更はViewStateを介してViewに反映され、単方向データフローを実現します。