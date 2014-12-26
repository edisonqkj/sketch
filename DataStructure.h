#pragma once

#define Key_UP 1
#define Key_DOWN 2
#define Key_RIGHT 3
#define Key_LEFT 4
#define PI 3.14159265358979

#include <gl\GL.h>
#include "MeshData.h"
#include <malloc.h>
#include <math.h>
#include <stdio.h>

struct StackofRing
{
	long num;
	long* base;
	long* top;
	int stacksize;

	long pop()
	{
		if(top==base)
		{
			//AfxMessageBox("Stack is Empty!");
			return -1;
		}
		else
		{
			return *(--top);
		}
	}
	void push(long id)
	{
		if(top-base>=stacksize)
			;//AfxMessageBox("Stack Overflows!");
		else
		{
			*(top++)=id;
			num++;
		}
	}
	void init()
	{
		num=0;
		stacksize=6;
		base=(long*)malloc(stacksize*sizeof(long));
		top=base;
	}
	void clear()
	{
		free(top);
		free(base);
		num=0;

		init();
	}
};

typedef struct QueueLongLink
{
	/// This structure is used from version 14-12-26
	/// as a substitute for QueueLong structure
	typedef struct NodeLong
	{
		long data;
		struct NodeLong* front;
		struct NodeLong* next;
	}NodeLong, *pNodeLong;

	long num;
	pNodeLong head;
	pNodeLong tail;
	
	void init()
	{
		head = NULL;
		tail = NULL;
		num = 0;
	}
	void enque(long n)
	{
		if (head == NULL)
		{
			head = (pNodeLong)malloc(sizeof(NodeLong));
			head->data = n;
			head->front = NULL;
			head->next = NULL;

			tail = head;
		}
		else
		{
			pNodeLong tmp = (pNodeLong)malloc(sizeof(NodeLong));
			tmp->data = n;
			tmp->front = tail;
			tmp->next = NULL;
			tail->next = tmp;

			tail = tmp;
		}
		num++;
	}
	long deque()
	{
		/// data is positive
		if (head == NULL)return-1;

		pNodeLong tmp = head;
		head = head->next;
		if (num == 1)
			tail = NULL;
		num--;
		long n = tmp->data;
		free(tmp);
		return n;
	}
	long* getArray()
	{
		if (head == NULL)return NULL;

		long* tmp = (long*)malloc(num*sizeof(long));
		if (tmp == NULL) return NULL;
		pNodeLong tmpnode = head;
		for (long i = 0; i < num; i++)
		{
			/// search link data
			tmp[i] = tmpnode->data;
			tmpnode = tmpnode->next;
		}
		return tmp;
	}
	bool exist(long n)
	{
		if (head == NULL) return false;

		pNodeLong tmp = head;
		while (tmp != NULL)
		{
			if (tmp->data == n)
				return true;
			tmp = tmp->next;
		}
		return false;
	}
	void removeat(long index)
	{
		if (head == NULL) return;
		if (index<0 || index>num - 1)
			return;//AfxMessageBox("Index error!");
		else if (index == 0)
			deque();
		else if (index == num - 1)
		{
			pNodeLong tmp = tail;
			tail->front->next = NULL;
			tail = tail->front;
			free(tmp);
			tmp = NULL;
		}
		else
		{
			pNodeLong tmp = head;
			for (long i = 0; i < index; i++)
			{
				tmp = tmp->next;
			}
			tmp->front->next = tmp->next;
			tmp->next->front = tmp->front;
			free(tmp);
			tmp = NULL;

			num--;
		}
	}
	void remove(long n)
	{
		if (head == NULL) return;

		if (head->data == n)
			deque();
		else
		{
			pNodeLong tmp = head->next;
			while (tmp != NULL)
			{
				if (tmp->data == n)
				{
					tmp->front->next = tmp->next;
					if (tmp == tail)
					{
						tail = tail->front;
					}
					else
					{
						tmp->next->front = tmp->front;
					}
					free(tmp);
					tmp = NULL;

					num--;
					break;/// remove first 'n'
				}//if
				tmp = tmp->next;
			}//while
		}
	}
	void setvalue(long index, long n)
	{
		/// update value
		if (head == NULL)return;
		if (index<0 || index>num - 1)return;
		//if (n < 0)return;
		if (index == 0)
			head->data = n;
		else if (index==num-1)
		{
			tail->data = n;
		}
		else
		{
			pNodeLong tmp = head;
			for (long i = 0; i < index; i++)
			{
				tmp = tmp->next;
			}
			tmp->data = n;
		}
	}
	long maxvalue()
	{
		if (head == NULL) return -1;

		if (num == 1)
			return head->data;
		long max = head->data;
		pNodeLong tmp = head->next;
		while (tmp != NULL)
		{
			if (tmp->data > max)
			{
				max = tmp->data;
			}//if
			tmp = tmp->next;
		}//while
		return max;
	}
	long minvalue()
	{
		if (head == NULL) return -1;

		if (num == 1)
			return head->data;
		long min = head->data;
		pNodeLong tmp = head->next;
		while (tmp != NULL)
		{
			if (tmp->data < min)
			{
				min = tmp->data;
			}//if
			tmp = tmp->next;
		}//while
		return min;
	}
	long sum()
	{
		if (head == NULL) return -1;

		if (num == 1)
			return head->data;
		long sum = head->data;
		pNodeLong tmp = head->next;
		while (tmp != NULL)
		{
			sum += tmp->data;
			tmp = tmp->next;
		}//while
		return sum;
	}
	void copyfrom(QueueLongLink* queue)
	{
		if (queue->head == NULL)return;

		/// cover all data
		if (head != NULL)
			this->clear();
		pNodeLong tmp = queue->head;
		while (tmp != NULL)
		{
			this->enque(tmp->data);
			tmp = tmp->next;
		}
	}
	long indexof(long n)
	{
		if (head == NULL) return -1;

		if (head->data == n)
			return 0;
		else if (tail->data == n)
			return num - 1;
		else
		{
			long index = 1;
			pNodeLong tmp = head->next;
			while (tmp != NULL)
			{
				if (tmp->data == n)
				{
					return index;
					break;/// return first 'n'
				}//if
				index++;
				tmp = tmp->next;
			}//while
			return -1;
		}
	}
	void clear()
	{
		while (head != NULL)
			this->deque();
		head = NULL;
		tail = NULL;
		num = 0;
	}
	void destory()
	{
		clear();
	}
	void print()
	{
		pNodeLong tmp = head;
		while (tmp!=NULL)
		{
			TRACE("%ld\n",tmp->data);
			tmp = tmp->next;
		}
	}
}QueueLongLink, *pQueueLongLink;

struct QueueLong
{
	/// This structure is abandoned from version 14-12-26
	long num;
	long* head;
	long* tail;
	long* initial_address;
	int queuesize;
	int queueincrement;

	long deque()
	{
		if(head==tail)
		{
			//AfxMessageBox("Stack is Empty!");
			return -1;
		}
		else
		{
			num--;
			if (head>tail)
			TRACE("head>tail\n");
			return *(head++);
		}
	}
	void enque(long id)
	{
		if(tail-head>=queuesize)
		{
			/*head=(long*)realloc(head,(queueincrement+queuesize)*sizeof(long));
			tail = head + queuesize;*/

			long* tmp = (long*)malloc((queueincrement + queuesize)*sizeof(long));
			for (long i = 0; i<num; i++)
				tmp[i] = head[i];
			head = tmp;/// original memory from head is not freed?
			tail = head + queuesize;
			initial_address = tmp;

			queuesize+=queueincrement;
		}
		*tail++=id;
		num++;
	}
	void removeat(long index)
	{
		if(index<0||index>num-1)
			;//AfxMessageBox("Index error!");
		else if(index==0)
			deque();
		else
		{
			//long* list=head;
			for(long i=index;i<num-1;i++)
			{
				head[i]=head[i+1];
			}
			tail--;
			num--;
			/// new list
			long* tmp = (long*)malloc(num*sizeof(long));
			for (long i = 0; i<num; i++)
				tmp[i] = head[i];
			head = tmp;/// original memory from head is not freed?
			tail = head + num;
			initial_address = tmp;
			//if (num>1)
			//	head = (long*)realloc(head, num*sizeof(long));// bug when num=1 or index =num-1
		}
	}
	void remove(long n)
	{
		if (num == 0)
			return;
		else
		{
			for (long i = 0; i < num; i++)
			{
				if (head[i] == n)
				{
					removeat(i);/// remove first one
					return;
				}
			}
		}
	}
	bool exist(long n)
	{
		if(num==0)
			return false;
		for(long i=0;i<num;i++)
			if(head[i]==n)
				return true;
		return false;
	}
	long maxvalue()
	{
		if (num == 0)
			return -1;
		if (num == 1)
			return head[0];
		long max = head[0];
		for (long i = 1; i<num; i++)
		if (head[i] >max)
			max = head[i];
		return max;
	}
	long minvalue()
	{
		if (num == 0)
			return -1;
		if (num == 1)
			return head[0];
		long min = head[0];
		for (long i = 1; i<num; i++)
		if (head[i] <min)
			min = head[i];
		return min;
	}
	long sum()
	{
		if (num == 0)
			return -1;
		long sum = 0;
		for (long i = 0; i < num; i++)
			sum += head[i];
		return sum;
	}
	long indexof(long n)
	{
		/// first equal
		for (long i = 0; i<num; i++)
		if (head[i] == n)
			return i;
		return -1;
	}
	void copyfrom(QueueLong* queue)
	{
		for (long i = 0; i < queue->num; i++)
			this->enque(queue->head[i]);
	}
	void init()
	{
		num=0;
		queuesize=6;
		queueincrement=10;
		head=(long*)malloc(queuesize*sizeof(long));
		tail=head;
		initial_address = head;
	}
	void clear()
	{
		while (num > 0)
			deque(); 
		//free(tail);
		//free(head);
		num=0;
		//tail=NULL;
		head=NULL;
		init();
	}
	void destory()
	{
		while (num > 0)
			deque();
		//free(head);
		head = NULL;
		tail = NULL;
		initial_address = NULL;
	}
	void print()
	{
		for (long i = 0; i < num; i++)
		{
			TRACE("%ld\n", head[i]);
		}
		TRACE("\n");
	}
};

struct HydroLine
{
	long ID;
	long Attribute;//domain
	long Magnitude;
	long PointNum;
	long* PointArray;//from i=0, to i=PointNum-1
	float (*Vertex)[3];
	bool IsGeneralized;//whether it will be shown after generalization
	HydroLine* next;

	long FlowNum;

	void init(long num)
	{
		ID=-1;
		Attribute=-1;
		Magnitude=-1;
		PointNum=num;
		PointArray=(long*)malloc(PointNum*sizeof(long));
		Vertex=(float(*)[3])malloc(PointNum*sizeof(float[3]));
		IsGeneralized = false;
		next=NULL;

		FlowNum=0;
	}
	void clear()
	{
		;
	}
	void input(float (*v)[3],long *id)
	{
		/// 倒序存储： 下游->上游
		for (long i = PointNum - 1; i >= 0; i--)
		{
			PointArray[PointNum - 1 - i] = id[i];
			Vertex[PointNum - 1 - i][0] = v[id[i]][0];
			Vertex[PointNum - 1 - i][1] = v[id[i]][1];
			Vertex[PointNum - 1 - i][2] = (float)(v[id[i]][2]);//+0.03);
		}
	}
	void smooth()
	{
		;
	}
};

struct HydroNode
{
	long ID;
	long Attribute;//domain
	long* UpLineNum;//n
	long* UpLine;
	long* DownLine;//1

	HydroNode* next;
};

class HydroTree
{
private:
	HydroLine* hLine;
	QueueLongLink*  NodeIdList;
	QueueLongLink* Leaves;/// index in NodeIdList
	QueueLongLink*  Node4Generalize;
	float* eye;/// current eye position eye[3]
	float scale;/// coordinate scale factor

public:
	HydroLine** HydroLineList;
	long** LinkMatrix;
	QueueLongLink* Roots;/// index in NodeIdList
	int OrderType;/// Strahler=0, Shreve=1;
	long NodeNum;
	long ValidLineNum;
	QueueLongLink* ValidLineIndex;

	HydroTree(HydroLine* _hLine)
	{
		hLine = _hLine;
		NodeIdList = NULL;
		NodeNum = 0;
		HydroLineList = NULL;
		LinkMatrix = NULL;
		OrderType = -1;
		Roots = NULL;
		Leaves = NULL;
		ValidLineNum = 0;
		ValidLineIndex = NULL;
		OrderType = -1;
		Node4Generalize = NULL;
		eye = NULL;
		scale = 1;
	}
	/// reset a new hydroline
	void Reset(HydroLine* _hLine)
	{
		if (hLine != NULL)
			destory();
		hLine = _hLine;
		NodeIdList = NULL;
		NodeNum = 0;
		HydroLineList = NULL;
		LinkMatrix = NULL;
		OrderType = -1;
		Roots = NULL;
		Leaves = NULL;
		ValidLineNum = 0;
		ValidLineIndex = NULL;
		OrderType = -1;
		Node4Generalize = NULL;
		eye = NULL;
		scale = 1;
	}
	/// 1. collect nodes such as stream head, stream node & outlet
	/// 2. create link matrix
	/// 3. make streams strahler or shreve order from leaf to root
	void BuildHydroTree()
	{
		getNodeId();
		initLinkMatrix();
		createLinkMatrix();
		getRootsAndLeaves();
	}
	void ClassifyByStrahler()
	{
		OrderType = 0;
		long* rhead = Roots->getArray();
		for (long rindex = 0; rindex < Roots->num; rindex++)
		{
			for (long col = 0; col < NodeNum; col++)
			{
				long row =rhead[rindex];
				long hydroLineIndex = LinkMatrix[row][col];
				if (hydroLineIndex != -1)
					IterateStrahlerOrder(col);
			}
		}
	}
	void ClassifyByShreve()
	{
		OrderType = 1;
		long* rhead = Roots->getArray();
		for (long rindex = 0; rindex < Roots->num; rindex++)
		{
			for (long col = 0; col < NodeNum; col++)
			{
				long row = rhead[rindex];
				long hydroLineIndex = LinkMatrix[row][col];
				if (hydroLineIndex != -1)
					IterateShreveOrder(col);
			}
		}
	}
	void ClearOrder()
	{
		OrderType = -1;
		long* vlihead = ValidLineIndex->getArray();
		for (long i = 0; i < ValidLineIndex->num; i++)
		{
			HydroLineList[vlihead[i]]->Magnitude = -1;
			HydroLineList[vlihead[i]]->IsGeneralized = false;
		}
	}
	void Generalize(double* cur_eye, float scale)
	{
		if (OrderType == -1) return;
		if (IsEyeChanged(cur_eye))
		{
			if (this->eye == NULL)
				this->eye = new float[3];
			this->eye[0] = cur_eye[0];
			this->eye[1] = cur_eye[1];
			this->eye[2] = cur_eye[2];
			this->scale = scale;

			Node4Generalize = new QueueLongLink;
			Node4Generalize->init();
			Node4Generalize->copyfrom(NodeIdList);

			/// from leafs to roots
			while (Leaves->num > 0)
			{
				long col = Leaves->deque();
				IterateGeneralizeStrahler(col);
			}
		}
	}
	void WriteAttributes(char* path)
	{
		TRACE("Roots Num: %ld\n",Roots->num);
		
		FILE* f = fopen(path, "w");
		fprintf(f, "Roots Num: %ld\n", Roots->num);
		/// 输出Root列表
		long* nilhead = NodeIdList->getArray();
		long* rhead = Roots->getArray();
		for (long a = 0; a < Roots->num; a++)
			fprintf(f, "Root %ld: %ld\n", a, nilhead[rhead[a]]);
		fprintf(f, "\n");
		/// 输出LinkMatrix
		for (long i = 0; i < NodeNum; i++)
		{
			//TRACE("id: %ld\t", NodeIdList->head[i]);
			fprintf(f, "id: %ld\t", nilhead[i]);
			for (long j = 0; j < NodeNum; j++)
			{
				//TRACE("%ld ", LinkMatrix[i][j]);
				fprintf(f, "%ld ", LinkMatrix[i][j]);
			}
			//TRACE("\n");
			fprintf(f, "\n");
		}
		/// 输出HydroLine列表
		fprintf(f, "FlowNum: %ld\n", hLine->FlowNum);
		for (long k = 0; k < ValidLineNum; k++)
		{
			fprintf(f, "HLine: %ld\t%ld\t%ld\t", HydroLineList[k]->ID, HydroLineList[k]->PointNum, HydroLineList[k]->Magnitude);
			/// 自相交情况
			if (HydroLineList[k]->PointArray[0] == HydroLineList[k]->PointArray[HydroLineList[k]->PointNum - 1])
			{
				for (long m = 0; m < HydroLineList[k]->PointNum; m++)
					fprintf(f, "%ld -> ", HydroLineList[k]->PointArray[m]);
				fprintf(f, "\n");
			}
			else/// 正常情况
				fprintf(f, "%ld -> %ld\t%f -> %f\t%ld\n", HydroLineList[k]->PointArray[0], HydroLineList[k]->PointArray[HydroLineList[k]->PointNum - 1],
																	   HydroLineList[k]->Vertex[0][2], HydroLineList[k]->Vertex[HydroLineList[k]->PointNum - 1][2],
																	   HydroLineList[k]->IsGeneralized);
		}
		fclose(f);
		//TRACE("Check tree.txt\n");
	}
	~HydroTree()
	{
		destory();
	}
private:
	void getNodeId()
	{
		HydroLine* tmpline = hLine;
		NodeIdList = new QueueLongLink;
		NodeIdList->init();

		HydroLineList = new HydroLine*[hLine->FlowNum];
		/// 1. collect nodes
		while (tmpline != NULL)
		{
			if (tmpline->PointNum>1)
			{
				/// store hydroline address
				HydroLineList[ValidLineNum] = tmpline;
				/// start - outlet
				if (!NodeIdList->exist(tmpline->PointArray[0]))
					NodeIdList->enque(tmpline->PointArray[0]);
				/// end - head
				if (!NodeIdList->exist(tmpline->PointArray[tmpline->PointNum - 1]))
					NodeIdList->enque(tmpline->PointArray[tmpline->PointNum - 1]);

				ValidLineNum++;
			}
			tmpline = tmpline->next;
		}
		NodeNum = NodeIdList->num;
		//tmpline = NULL;
	}
	void initLinkMatrix()
	{
		/// 2. initialize link matrix
		/// i refers to the index of start, j refers to the index of end in nodeid queue
		/// (i,j) refers to the index of its hydroline address
		LinkMatrix = new long*[NodeNum];
		for (long ii = 0; ii < NodeNum; ii++)
		{
			LinkMatrix[ii] = new long[NodeNum];
			for (long jj = 0; jj < NodeNum; jj++)
				LinkMatrix[ii][jj] = -1;
		}
	}
	void createLinkMatrix()
	{
		/// store index of the valid hydroline in HydroLineList
		/// ValidLineNum is not correct when outlets point to each other
		ValidLineIndex = new QueueLongLink;
		ValidLineIndex->init();

		/// 3. create link matrix
		for (long i = 0; i<ValidLineNum; i++)
		{
			if (HydroLineList[i]->PointNum > 1)
			{
				/// get index of start & end
				long i_linkmatrix = NodeIdList->indexof(HydroLineList[i]->PointArray[0]),
						j_linkmatrix = NodeIdList->indexof(HydroLineList[i]->PointArray[HydroLineList[i]->PointNum - 1]);
				/// store (i,j) into link matrix (start->end)
				/// Bug fixed: For ridges at a flat place, outlets point to each other,
				/// which causes a loss of roots from link matrix.
				if (LinkMatrix[j_linkmatrix][i_linkmatrix] == -1)
				{
					LinkMatrix[i_linkmatrix][j_linkmatrix] = i;
					ValidLineIndex->enque(i);
				}
			}
		}
	}
	void getRootsAndLeaves()
	{
		/// 4. find Root & Leaf
		/// Root - all value are -1 in the column
		/// Leaf -  all value are -1 in the row
		Roots = new QueueLongLink;
		Roots->init();
		Leaves = new QueueLongLink;
		Leaves->init();
		long in_row, in_col;
		for (long i = 0; i < NodeNum; i++)
		{
			in_row = 0; in_col = 0;
			for (long j = 0; j < NodeNum; j++)
			{
				/// find Leaves
				if (LinkMatrix[i][j] != -1)
					in_row++;
				/// find roots
				if (LinkMatrix[j][i] != -1)
					in_col++;
			}
			if (in_col == 0)
				Roots->enque(i);
			if (in_row == 0)
				Leaves->enque(i);
		}
	}
	void IterateStrahlerOrder(long fatherIndex)
	{
		/// iterate to order each hydroline by Strahler method
		long childnum = 0;
		long hydroLineIndex;
		QueueLongLink* magnitudeList = new QueueLongLink;
		magnitudeList->init();

		for (long childIndex = 0; childIndex < NodeNum; childIndex++)
		{
			hydroLineIndex = LinkMatrix[fatherIndex][childIndex];
			if (hydroLineIndex != -1)
			{
				childnum++;
				long mag = HydroLineList[hydroLineIndex]->Magnitude;
				if (mag == -1)
				{
					IterateStrahlerOrder(childIndex);
					mag = HydroLineList[hydroLineIndex]->Magnitude;
				}

				/// judge each magnitude
				if (!magnitudeList->exist(mag))
					magnitudeList->enque(mag);
			}
		}

		/// set magnitude value of father hydroline
		long grandfatherIndex = findFatherIndex(fatherIndex);
		hydroLineIndex = LinkMatrix[grandfatherIndex][fatherIndex];
		if (childnum > 0)
		{
			/// childnum ranges in [0,1,2,3,...]
			/// each substream has the same magnitude
			if (childnum > 1 && magnitudeList->num == 1)
			{
				/// (2,2)->3
				HydroLineList[hydroLineIndex]->Magnitude = magnitudeList->maxvalue() + 1;
			}
			else/// one substream or different magnitudes, set as the max
			{
				/// (2)->2 or (1,2,3)->3
				HydroLineList[hydroLineIndex]->Magnitude = magnitudeList->maxvalue();
			}
		}
		else/// leaf node
		{
			HydroLineList[hydroLineIndex]->Magnitude = 1;
		}
	}
	void IterateShreveOrder(long fatherIndex)
	{
		/// iterate to order each hydroline by Strahler method
		long childnum = 0;
		long hydroLineIndex;
		QueueLongLink* magnitudeList = new QueueLongLink;
		magnitudeList->init();

		for (long childIndex = 0; childIndex < NodeNum; childIndex++)
		{
			hydroLineIndex = LinkMatrix[fatherIndex][childIndex];
			if (hydroLineIndex != -1)
			{
				childnum++;
				long mag = HydroLineList[hydroLineIndex]->Magnitude;
				if (mag == -1)
				{
					IterateShreveOrder(childIndex);
					mag = HydroLineList[hydroLineIndex]->Magnitude;
				}

				/// judge each magnitude
				magnitudeList->enque(mag);
			}
		}

		/// set magnitude value of father hydroline
		long grandfatherIndex = findFatherIndex(fatherIndex);
		hydroLineIndex = LinkMatrix[grandfatherIndex][fatherIndex];
		if (childnum > 0)
		{
			/// childnum ranges in [0, 2,3,...]
			/// sum all the substream magnitude
			HydroLineList[hydroLineIndex]->Magnitude = magnitudeList->sum();
		}
		else/// leaf node
		{
			HydroLineList[hydroLineIndex]->Magnitude = 1;
		}
	}
	void IterateGeneralizeStrahler(long childIndex)
	{
		long* nilhead = NodeIdList->getArray();
		Node4Generalize->remove(nilhead[childIndex]);
		if (Leaves->exist(childIndex))
			Leaves->remove(childIndex);

		long fatherIndex = findFatherIndex(childIndex);
		if (fatherIndex != -1)
		{
			long hydroLineIndex = LinkMatrix[fatherIndex][childIndex];
			IsGeneralized(hydroLineIndex);
			/// if substream isn't generalized, all father streams are kept.
			if (!HydroLineList[hydroLineIndex]->IsGeneralized)
			{
				do
				{
					hydroLineIndex = LinkMatrix[fatherIndex][childIndex];
					HydroLineList[hydroLineIndex]->IsGeneralized = false;
					/// has been checked from other leaf
					if (!Node4Generalize->exist(nilhead[fatherIndex]))
						return;
					Node4Generalize->remove(nilhead[fatherIndex]);

					if (Leaves->exist(fatherIndex))
						Leaves->remove(fatherIndex);
					/// falsen the father streams which are true somewhere else
					childIndex = fatherIndex;
					fatherIndex = findFatherIndex(childIndex);
				} while (fatherIndex != -1);
			}
			else/// isgeneralized=true
			{
				/// check other brothers
				for (long i = 0; i < NodeNum; i++)
				{
					if (i == childIndex)
						continue;
					long brotherHydroIndex = LinkMatrix[fatherIndex][i];
					if (brotherHydroIndex != -1 && Node4Generalize->exist(nilhead[i]))
					{
						IterateGeneralizeStrahler(i);
					}
				}
				/// if all children is generalized, father will be the next leave.
				if (Node4Generalize->exist(nilhead[fatherIndex]))
				{
					if (!Leaves->exist(fatherIndex))
						Leaves->enque(fatherIndex);
				}
			}
		}
	}
	void IsGeneralized(long hydroLineIndex)
	{
		/// every hydroline has a magnitude (>0)
		long mag = HydroLineList[hydroLineIndex]->Magnitude,
				pointNum = HydroLineList[hydroLineIndex]->PointNum;
		/// judge visibility based on depth(i) of level(i)
		float(*Vertex)[3] = HydroLineList[hydroLineIndex]->Vertex;
		float min_dis = getP2PDistance3D(Vertex[0], eye);
		long min_dis_index = 0;
		for (long i = 1; i <pointNum; i++)
		{
			float dis = getP2PDistance3D(Vertex[i], eye);
			if (dis < min_dis)
			{
				min_dis = dis;
				min_dis_index = i;
			}
		}
		float depthdomain = DepthDomainOfMagnitude(mag);
		//TRACE("min_dis: %f, domain: %f\n", min_dis,depthdomain);
		if (min_dis>depthdomain)
			HydroLineList[hydroLineIndex]->IsGeneralized = true;
		else
			HydroLineList[hydroLineIndex]->IsGeneralized = false;
	}
	float DepthDomainOfMagnitude(long mag)
	{
		/// depth function of magnitude
		if (mag == 1)
			return 1500 / scale;
		else
			return 10000;
	}
	float getP2PDistance2D(float* p1, float* p2)
	{
		/// sqrt(x^2+y^2)
		return sqrt((p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*(p1[1] - p2[1]));
	}
	float getP2PDistance3D(float* p1, float* p2)
	{
		/// sqrt(x^2+y^2+z^2)
		return sqrt((p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*(p1[1] - p2[1]) + (p1[2] - p2[2])*(p1[2] - p2[2]));
	}
	long findFatherIndex(long childIndex)
	{
		/// each child node has only one father node
		/// find father's index in link matrix
		for (long i = 0; i < NodeNum; i++)
		{
			if (LinkMatrix[i][childIndex] != -1)
				return i;
		}
		return -1;
	}
	bool IsEyeChanged(double* cur_eye)
	{
		if (eye == NULL)
			return true;
		if (eye[0] != cur_eye[0] || eye[1] != cur_eye[1] || eye[2] != cur_eye[2])
			return true;
		return false;
	}
	void destory()
	{
		/*if (hLine != NULL)
		{
		delete hLine;
		hLine = NULL;
		}*/
		if (NodeIdList != NULL)
		{
			NodeIdList->destory();
			NodeIdList = NULL;
		}
		if (HydroLineList != NULL)
		{
			delete[] HydroLineList;
			NodeIdList = NULL;
		}
		if (LinkMatrix != NULL)
		{
			for (long i = 0; i < NodeNum; i++)
			{
				delete[] LinkMatrix[i];
				LinkMatrix[i] = NULL;
			}
			delete[] LinkMatrix;
			LinkMatrix = NULL;
		}
		if (Roots != NULL)
		{
			Roots->destory();
			Roots = NULL;
		}
		if (Leaves != NULL)
		{
			Leaves->destory();
			Leaves = NULL;
		}
		if (ValidLineIndex != NULL)
		{
			ValidLineIndex->destory();
			ValidLineIndex = NULL;
		}
		if (Node4Generalize != NULL)
		{
			//Node4Generalize->destory();
			Node4Generalize = NULL;
		}
		if (eye != NULL)
		{
			delete[] eye;
			eye = NULL;
		}
	}
};
