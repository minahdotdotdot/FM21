classdef bayesianRegressionLayer < nnet.layer.RegressionLayer
        
    properties
        % (Optional) Layer properties.
        %Name
        %Description
        % Layer properties go here.
    end
 
    methods
        function layer = bayesianRegressionLayer(name)           
            % (Optional) Create a myRegressionLayer.
            % Layer constructor function goes here.
            layer.Name = name;
            layer.Description='The predictor parametrizes the normal distribution.';
        end

        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the training
            % targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T
            mu = Y(1,:); sigmavar = Y(2,:);
            sigmavar = log(1+exp(sigmavar));
            % Layer forward loss function goes here.
            NLL = -log(1 ./(sqrt(2*pi)*sigmavar))+1/2*((T(1,:)-mu)./sigmavar).^2;
            % Average over minibatch.
            loss = mean(NLL,2);
        end
        
        % function dLdY = backwardLoss(layer, Y, T)
        %     % (Optional) Backward propagate the derivative of the loss 
        %     % function.
        %     %
        %     % Inputs:
        %     %         layer - Output layer
        %     %         Y     – Predictions made by network
        %     %         T     – Training targets
        %     %
        %     % Output:
        %     %         dLdY  - Derivative of the loss with respect to the 
        %     %                 predictions Y        
        %     mu = Y(1,:); sigmavar = Y(2,:);
        %     % Layer backward loss function goes here.
        %     dLdY = [Y(1,:)-T./Y(2,:); (1./Y(2,:) + (Y(1,:)-T)./(Y(2,:).^3))];
        % end
    end
end