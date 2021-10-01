classdef one_protein
	% This file was automatically generated by OneModel.
	% Any changes you make to it will be overwritten the next time
	% the file is generated.

	properties
		p      % Default model parameters.
		x0     % Default initial conditions.
		M      % Mass matrix for DAE systems.
		opts   % Simulation options.
	end

	methods
		function obj = one_protein()
			%% Constructor of one_protein.
			obj.p    = obj.default_parameters();
			obj.x0   = obj.initial_conditions();
			obj.M    = obj.mass_matrix();
			obj.opts = obj.simulation_options();
		end

		function p = default_parameters(~)
			%% Default parameters value.
			p = [];
			p.p_A__N = 1.0;
			p.p_A__omega = 10.0;
			p.p_A__d_m = 0.16;
			p.p_A__k_b = 4.7627;
			p.p_A__k_u = 119.7956;
			p.p_A__l_p = 195.0;
			p.p_A__l_e = 25.0;
		end

		function x0 = initial_conditions(~)
			%% Default initial conditions.
			x0 = [
				100.0 % p_A__m
			];
		end

		function M = mass_matrix(~)
			%% Mass matrix for DAE systems.
			M = [
				1 
			];
		end

		function opts = simulation_options(~)
			%% Default simulation options.
			opts.t_end = 10.0;
			opts.t_init = 0.0;
		end

		function dx = ode(~,t,x,p)
			%% Evaluate the ODE.
			%
			% Args:
			%	 t Current time in the simulation.
			%	 x Array with the state value.
			%	 p Struct with the parameters.
			%
			% Return:
			%	 dx Array with the ODE.

			% ODE and algebraic states:
			p_A__m = x(1,:);

			% Assigment states:
			p_A__nu = 1;
			p_A__mu = 1;
			p_A__r = 1;
			p_A__m_h = 1;
			p_A__J_host_sum = 1;
			p_A__K_C0 = p.p_A__k_b./(p.p_A__k_u + p_A__nu./p.p_A__l_e);
			p_A__E_m = 0.62.*p.p_A__l_p./p.p_A__l_e;
			p_A__J = p_A__E_m.*p.p_A__omega./(p.p_A__d_m./p_A__K_C0 + p_A__mu.*p_A__r);

			% der(p_A__m)
			dx(1,1) = (p_A__m_h.*p.p_A__N.*p_A__J./p_A__J_host_sum - p_A__m).*p_A__mu;

		end
		function out = simout2struct(~,t,x,p)
			%% Convert the simulation output into an easy-to-use struct.

			% We need to transpose state matrix.
			x = x';
			% ODE and algebraic states:
			p_A__m = x(1,:);

			% Assigment states:
			p_A__nu = 1;
			p_A__mu = 1;
			p_A__r = 1;
			p_A__m_h = 1;
			p_A__J_host_sum = 1;
			p_A__K_C0 = p.p_A__k_b./(p.p_A__k_u + p_A__nu./p.p_A__l_e);
			p_A__E_m = 0.62.*p.p_A__l_p./p.p_A__l_e;
			p_A__J = p_A__E_m.*p.p_A__omega./(p.p_A__d_m./p_A__K_C0 + p_A__mu.*p_A__r);

			% Save simulation time.
			out.t = t;

			% Vector for extending single-value states and parameters.
			ones_t = ones(size(t'));


			% Save states.
			out.p_A__nu = p_A__nu.*ones_t;
			out.p_A__mu = p_A__mu.*ones_t;
			out.p_A__r = p_A__r.*ones_t;
			out.p_A__m_h = p_A__m_h.*ones_t;
			out.p_A__J_host_sum = p_A__J_host_sum.*ones_t;
			out.p_A__K_C0 = p_A__K_C0.*ones_t;
			out.p_A__E_m = p_A__E_m.*ones_t;
			out.p_A__J = p_A__J.*ones_t;
			out.p_A__m = p_A__m.*ones_t;

			% Save parameters.
			out.p_A__N = p.p_A__N.*ones_t;
			out.p_A__omega = p.p_A__omega.*ones_t;
			out.p_A__d_m = p.p_A__d_m.*ones_t;
			out.p_A__k_b = p.p_A__k_b.*ones_t;
			out.p_A__k_u = p.p_A__k_u.*ones_t;
			out.p_A__l_p = p.p_A__l_p.*ones_t;
			out.p_A__l_e = p.p_A__l_e.*ones_t;

		end
		function plot(~,out)
			%% Plot simulation result.
			figure('Name','p_A');
			subplot(3,3,1);
			plot(out.t, out.p_A__nu);
			title("p_A__nu");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,2);
			plot(out.t, out.p_A__mu);
			title("p_A__mu");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,3);
			plot(out.t, out.p_A__r);
			title("p_A__r");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,4);
			plot(out.t, out.p_A__m_h);
			title("p_A__m_h");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,5);
			plot(out.t, out.p_A__J_host_sum);
			title("p_A__J_host_sum");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,6);
			plot(out.t, out.p_A__K_C0);
			title("p_A__K_C0");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,7);
			plot(out.t, out.p_A__E_m);
			title("p_A__E_m");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,8);
			plot(out.t, out.p_A__J);
			title("p_A__J");
			ylim([0, +inf]);
			grid on;

			subplot(3,3,9);
			plot(out.t, out.p_A__m);
			title("p_A__m");
			ylim([0, +inf]);
			grid on;

		end
	end
end
