

# examples=(
# 	'data/nerf4/chair'
# 	'data/nerf4/drums'
# 	'data/nerf4/ficus'
# 	'data/nerf4/mic'
# )

# for i in "${examples[@]}"; do
# 	filename=$(basename "$i")
# 	bash scripts/textual_inversion/textual_inversion.sh 0 runwayml/stable-diffusion-v1-5 "$i"/rgba.png out/textual_inversion/${filename} _nerf_${filename}_ ${filename} --max_train_steps 3000
# done


device=$1
# bash scripts/textual_inversion/textual_inversion.sh $device runwayml/stable-diffusion-v1-5 data/demo/blackpink-lisa/image.png out/textual_inversion/data/demo/blackpink-lisa _blackpink_lisa_ lisa --max_train_steps 3000

# bash scripts/textual_inversion/textual_inversion.sh $device runwayml/stable-diffusion-v1-5 data/demo/blackpink-lisa/image.png out/textual_inversion/data/demo/a-fullbody-ironman _ironman_ ironman --max_train_steps 3000

# bash scripts/textual_inversion/textual_inversion.sh $device runwayml/stable-diffusion-v1-5 data/demo/taylor-swift-sit-1989/image.png out/textual_inversion/data/demo/taylor-swift-sit _taylor_swift_sit_ taylor --max_train_steps 3000
bash scripts/textual_inversion/textual_inversion.sh $device runwayml/stable-diffusion-v1-5 data/demo/taylor-swift-in-red-hat-blue-t-shift-light-green-skirt-long-black-sock-red-high-heel-shoe-with-a-blue-bag/image.png out/textual_inversion/data/demo/taylor-swift2 _taylor_swift_2_ taylor --max_train_steps 3000