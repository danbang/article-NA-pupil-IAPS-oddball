### Directory structure

Each subject directory contains three files:

- behavior.parquet — behavioral data
- predictions.parquet — neuromodulator predictions
- pupillometry.parquet — pre-processed pupillometry



### About Parquet files

Parquet files are binary, cross-platform, compressed tabular data files from [Apache](https://parquet.apache.org/). They can be read like so:

- Matlab: via built-in `parquetread()`
- R: via `read_parquet()` from the [arrow](https://arrow.apache.org/docs/r/) package
- Python: via `read_parquet()` from the [pandas](https://pandas.pydata.org/) package



### Data Dictionary

#### behavior.parquet

In this file, behavioral events are presented in tabular form. Each row represents a punctate event, though not necessarily a unique point in time, as some events happen concurrently. Except for the **time** and **eventType** columns, each column represents a task state variable for each event. The values of these variables represent the task state immediately after the event takes place. In other words, if an event results in a change in task state, the new value will be reflected in the event row.

##### Variables

- **time**: time in seconds
- **eventType**: event (see table below)
- **block**: block number
- **blockName**: block name
- **round**: round/trial number within the current block
- **trial**: overall round/trial number
- **imageFile**: filename of presented image
- **imageType**: indicates "standard" or "oddball" image
- **key**: which key was pressed (see `KEY RESPONSE` event)
- **reactionTime**: elapsed time (in seconds) between cue and response (see `IMAGE` and `KEY RESPONSE` events)

##### Event Types

| eventType    | description                                   |
| ------------ | --------------------------------------------- |
| SYNC         | timing synchronization pulse received by task |
| NEW BLOCK    | marker for the start of a new block           |
| NEW ROUND    | marker for the start of a new round/trial     |
| IMAGE        | image presented on screen                     |
| FIXATION     | image removed from screen                     |
| KEY RESPONSE | key pressed as response to image              |
| KEY IGNORED  | key pressed outside of image response window  |

