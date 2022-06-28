# Human-in-the-loop-RL
This repository is for the Dual Degree Project done by Saarthak Marathe on the topic of 'Human-in-the-loop Reinforcement Learning'.
The methods discussed have been put in separate folders within this repo. 

All the methods used here are based on an [Anaconda](https://docs.anaconda.com/anaconda/install/linux/) environment and Ubuntu 20.04 interface.

## Human-in-the-loop with TD3 base

This method is tested on [MuJoCo](http://www.mujoco.org/) continuous control tasks in [OpenAI gym](https://github.com/openai/gym). 
Networks are trained using [PyTorch 1.2](https://github.com/pytorch/pytorch) and Python 3.7. 

### Setting up MuJoCo

For this, we need to setup MuJoCo first. That can be done by following the procedure given below: <br>
First, download the Mujoco library from 
```
    https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
```
Then, create a hidden folder :
```
     mkdir /home/username/.mujoco
```
Extract the library to the <code> .mujoco </code> folder

Include these lines in <code> .bashrc </code> file:
```
    export LD_LIBRARY_PATH=/home/user_name/.mujoco/mujoco210/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia
    export PATH="$LD_LIBRARY_PATH:$PATH"
    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so
```

Then do <code> source .bashrc </code>

Test that the library is installed by going into:
```
     cd ~/.mujoco/mujoco210/bin
    ./simulate ../model/humanoid.xml
```

Install mujoco-py:
```
    conda create --name mujoco_py python=3.8
    conda activate mujoco_py
    sudo apt update
    sudo apt-get install patchelf
    sudo apt-get install python3-dev build-essential libssl-dev libffi-dev libxml2-dev  
    sudo apt-get install libxslt1-dev zlib1g-dev libglew1.5 libglew-dev python3-pip
```

```
    git clone https://github.com/openai/mujoco-py
    cd mujoco-py
    pip install -r requirements.txt
    pip install -r requirements.dev.txt
    pip3 install -e . --no-cache
```

Then, reboot your machine and run the following commands:
```
    conda activate mujoco_py
    sudo apt install libosmesa6-dev libgl1-mesa-glx libglfw3
    sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
```

Once we are done setting up MuJoCo, we move to the <code> HumanTD3 </code> folder which is used for the implementation of the method.

### Files

- <code> TD3.py </code>: Base code of the TD3 RL agent <br>
- <code> HumanTD3.py </code>: This gives us the modified TD3 base algorithm with the human involvement. This takes the input and updates the value function, loss functions based on the changes presented in the paper. <br>
- <code> main.py </code>: This python file is used for the implementation of the code presented in the previous two files where we give values to the hyper-parameters for the algorithms and also choose which policy to implement. <br>
- <code> utils.py </code>: Defines the variables used

Experiments on single environments can be run by calling:
```
conda activate mujoco_py
cd ~/HumanTD3
python main.py --policy HumanTD3 --env Hopper-v2
```
Here, the policy caan be chosen between TD3, HumanTD3.

For running the simulations and get the results for both the algorithms together, the following shell file can be run after initializing it with <code> chmod </code>
```
conda activate mujoco_py
cd ~/HumanTD3
./run_experiments.sh
```

### Results

Evaluations are peformed every 5000 time steps, over a total of 1 million time steps. The results of the simulations are stored in the <code> results </code> folder. These can be further  utilized to plot learning curves and visualize the same.

========================================================================

## Advantage-based Intervention with human-in-the-loop 

Code based on [OpenAI](https://github.com/openai/)'s [Spinning Up](https://spinningup.openai.com). So for this, we need to setup SpinningUp to proceed.

### Setting up

We follow the instructions given in https://spinningup.openai.com/en/latest/user/installation.html. Except for following parts, we follow the link as it is:
    - Replace `conda create -n spinningup python=3.6` and `conda activate spinningup` with `conda create -n hmn_adv_safe python=3.6` and `conda activate hmn_adv_safe`, respectively.
	- Instead of the "Installing Spinning Up" section, run the following:
    ```
    cd Human_Adv_SafeRL
    pip install -e .
    ```
    - Install MuJoCo in the same manner as shown in the previous part of this README.md and initiate in this <code> hmn_adv_safe </code> virtual env
    - Rest of the link needs to be followed as it is

Go to the `extra_envs` directory and install it to expose those environments to Gym.
```
cd extra_envs
pip install -e .
```

### Folders and files

1. `extra_envs`: Has three folders for envs, wrappers and interveners. They are explained as follows:
	- `envs`: Has the point env
	- `wrappers`: Used as intervention wrapper. `step` is used to check if agent should intervene. If it is not required then we `step` the internal env. Otherwise, NaN is returned and `done` flag is set to `True`. If intervener gives safe action, dic `info` hhas the `step` output when safe action is applied to the internal env from intervener
	- `intervener`: Intervention rule G wiht the human intervention for point env. It contains `should_intervene` method to decide whether action requires intervention. `safe_action` returns safe action from the policy. For the poin env, we have two interveners described as follows:
		- `PointIntervenerNetwork`: Uses V and Q approximators to build advantage function estimate. Networks loaded using PyTorch
		- `PointIntervenerRollout`: Gives deceleration policy to model of env to build estimate
2. `hmn_adv_saferl/algos`:
	- `cppo`: PPO algorithm modified for the constrained/safe setting. Our implementation maintains a value function for the reward and a value function to predict the constraint cost or an intervention (here, overloaded into the same scalar). Thus, CPPO can be used for both the constrained setting where a Lagrange multiplier is optimized and the unconstrained safe setting where we receive a fixed penalty for an intervention.
	- `csc`: constrained PPO algorithm but with a state-action critic used for the cost in place of the state critic. The state-action "safety" critic is used to filter out unsafe proposed actions, and is trained in a conservative fashion to make the agent more safe.
3. Other files in `hmn_adv_saferl` folder are used to initialize, run the algorithms descirbed above
4. 


