function noisy_image = add_salt_pepper_noise(image, probability)
    % image: 输入的灰度图像
    % probability: 添加椒盐噪声的概率
 
    [rows, cols] = size(image);
    salt_pepper_noise = zeros(rows, cols); % 初始化一个与原图相同大小的噪声图像
 
    % 遍历图像中的每个像素，根据概率添加椒盐噪声
    for i = 1:rows
        for j = 1:cols
            if rand < probability
                % 添加椒盐噪声：1代表椒盐（白色噪点）
                salt_pepper_noise(i, j) = 1;
            elseif rand < 2*probability
                % 添加椒盐噪声：0代表盐粉（黑色块）
                salt_pepper_noise(i, j) = 0;
            end
        end
    end
 
    % 将噪声图像添加到原始图像上
    noisy_image = image + salt_pepper_noise;
 
    % 确保图像的像素值在0到255之间
    noisy_image(noisy_image > 255) = 255;
    noisy_image(noisy_image < 0) = 0;
end