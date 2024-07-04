#define CLUSTER_NUMBER 7
register<bit<DISTANCE_WIDTH>>(CLUSTER_NUMBER) registerDistances;

action calc_distance(bit<NORMALIZED_WIDTH> feature, bit<NORMALIZED_WIDTH> cluster, bit<32> clusterIndex){
	bit<DISTANCE_WIDTH> clusDist;
	registerDistances.read(clusDist, clusterIndex);

	bit<DISTANCE_WIDTH> thisDistance;

	bit<DISTANCE_WIDTH> featureBigger;
	bit<DISTANCE_WIDTH> clusterBigger;

	featureBigger = (bit<DISTANCE_WIDTH>)(feature |-| cluster);
	clusterBigger = (bit<DISTANCE_WIDTH>)(cluster |-| feature);

	thisDistance = featureBigger + clusterBigger;

	registerDistances.write(clusterIndex, clusDist + thisDistance);
}
